import Foundation
import Combine

final class RoadmapViewModel: ObservableObject {
    @Published var selected: Philosopher = .plato
    @Published var steps: [RoadmapStep] = RoadmapTemplate.steps(for: .plato)

    /// 필독(큐레이션) - 단계별
    @Published var curatedStepBooks: [[CuratedResolvedBook]] = [[], [], []]

    /// 확장 읽기(베스트셀러에서 필터링) - 단계별
    @Published var extendedStepBooks: [[BookItem]] = [[], [], []]

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api: AladinServicing
    private var bag = Set<AnyCancellable>()

    /// 연속 선택 변경 시, 늦게 도착한 이전 요청이 UI를 덮어쓰는(out-of-order) 문제를 차단하기 위한 토큰
    private var currentRefreshID = UUID()

    /// 현재 refresh 파이프라인(취소 가능)
    private var refreshCancellable: AnyCancellable?

    // 확장 추천을 위해 베스트셀러를 몇 페이지 스캔할지
    private let bestsellerPagesToScan = AppConfig.bestsellerPagesToScan
    private let pageSize = AppConfig.aladinPageSize

    init(api: AladinServicing = AladinAPI()) {
        self.api = api
        bind()
        refresh(p: .plato)
    }

    private func bind() {
        $selected
            .removeDuplicates()
            .sink { [weak self] p in
                guard let self else { return }
                steps = RoadmapTemplate.steps(for: p)
                refresh(p: p)
            }
            .store(in: &bag)
    }

    func refresh(p: Philosopher) {
        // ✅ 이전 refresh 요청 취소 + 새 토큰 발급
        refreshCancellable?.cancel()
        refreshCancellable = nil
        let refreshID = UUID()
        currentRefreshID = refreshID

        isLoading = true
        errorMessage = nil
        curatedStepBooks = [[], [], []]
        extendedStepBooks = [[], [], []]

        // 1) 필독(큐레이션) 로드 + 알라딘 매칭
        let curated = CuratedRoadmap.books(for: p)
        

        refreshCancellable =
        matchCuratedBooks(curated)
            // ✅ UI 상태 업데이트는 항상 메인에서
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] resolved -> AnyPublisher<Void, Error> in
                guard let self else { return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }

                // ✅ 늦게 도착한 이전 요청이면 무시
                guard self.currentRefreshID == refreshID else {
                    return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
                }

                self.assignCuratedToSteps(resolved)

                // 2) 확장 읽기: 베스트셀러 다페이지 → 철학자 관련만 필터링 → 큐레이션과 중복 제거 → 단계 분류
                return self.loadExtendedRecommendations(for: p, excluding: resolved)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                // ✅ 늦게 도착한 이전 요청이면 UI를 건드리지 않음
                guard self.currentRefreshID == refreshID else { return }

                self.isLoading = false
                if case let .failure(err) = completion {
                    self.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                guard self.currentRefreshID == refreshID else { return }
                // done
            }
    }

    // MARK: - Curated Matching (필독)
    private func matchCuratedBooks(_ curated: [CuratedBook]) -> AnyPublisher<[CuratedResolvedBook], Error> {
        guard !curated.isEmpty else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let pubs = curated.map { book in
            matchOneCurated(book)
                .map { CuratedResolvedBook(curated: book, matched: $0) }
                .eraseToAnyPublisher()
        }

        return Publishers.MergeMany(pubs)
            .collect()
            .map { list in
                // 입력 순서 유지(단계/제목)
                list.sorted { (a, b) in
                    if a.curated.step == b.curated.step { return a.curated.title < b.curated.title }
                    return a.curated.step < b.curated.step
                }
            }
            .eraseToAnyPublisher()
    }

    private func matchOneCurated(_ curated: CuratedBook) -> AnyPublisher<BookItem?, Error> {
        // 1차: Keyword(제목+저자) → 2차: Title → 3차: Author
        let q1 = "\(curated.title) \(curated.author)"
        let q2 = curated.title
        let q3 = curated.author

        return api.fetch(.itemSearch(query: q1, queryType: AppConfig.aladinQueryTypeKeyword, start: 1, maxResults: AppConfig.aladinMaxResults))
            .map { self.pickBestMatch(from: $0.item ?? [], curated: curated) }
            .flatMap { match -> AnyPublisher<BookItem?, Error> in
                if match != nil { return Just(match).setFailureType(to: Error.self).eraseToAnyPublisher() }

                return self.api.fetch(.itemSearch(query: q2, queryType: AppConfig.aladinQueryTypeTitle, start: 1, maxResults: AppConfig.aladinMaxResults))
                    .map { self.pickBestMatch(from: $0.item ?? [], curated: curated) }
                    .flatMap { match2 -> AnyPublisher<BookItem?, Error> in
                        if match2 != nil { return Just(match2).setFailureType(to: Error.self).eraseToAnyPublisher() }

                        return self.api.fetch(.itemSearch(query: q3, queryType: AppConfig.aladinQueryTypeAuthor, start: 1, maxResults: AppConfig.aladinMaxResults))
                            .map { self.pickBestMatch(from: $0.item ?? [], curated: curated) }
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private func pickBestMatch(from items: [BookItem], curated: CuratedBook) -> BookItem? {
        guard !items.isEmpty else { return nil }

        let wantedTitles = ([curated.title] + curated.altTitles).map { normalize($0) }
        let wantedAuthor = normalize(curated.author)

        func score(_ b: BookItem) -> Int {
            let t = normalize(b.title ?? AppConfig.emptyString)
            let a = normalize(b.author ?? AppConfig.emptyString)

            var s = 0
            if wantedTitles.contains(where: { t.contains($0) || $0.contains(t) }) { s += AppConfig.scoreTitleMatch }
            if !wantedAuthor.isEmpty, a.contains(wantedAuthor) { s += AppConfig.scoreAuthorMatch }
            if (b.isbn13 ?? AppConfig.emptyString).count == 13 { s += AppConfig.scoreIsbnCoverMatch }
            if (b.cover ?? AppConfig.emptyString).isEmpty == false { s += AppConfig.scoreIsbnCoverMatch }
            return s
        }

        return items
            .map { ($0, score($0)) }
            .sorted { $0.1 > $1.1 }
            .first(where: { $0.1 >= AppConfig.bestMatchScoreThreshold })?.0
    }

    private func normalize(_ s: String) -> String {
        s.lowercased()
            .replacingOccurrences(of: AppConfig.normalizeSpace, with: AppConfig.emptyString)
            .replacingOccurrences(of: AppConfig.normalizeDot, with: AppConfig.emptyString)
            .replacingOccurrences(of: AppConfig.normalizeColon, with: AppConfig.emptyString)
            .replacingOccurrences(of: AppConfig.normalizeDashLong, with: AppConfig.emptyString)
            .replacingOccurrences(of: AppConfig.normalizeDashShort, with: AppConfig.emptyString)
            .replacingOccurrences(of: AppConfig.normalizeParenthesisOpen, with: AppConfig.emptyString)
            .replacingOccurrences(of: AppConfig.normalizeParenthesisClose, with: AppConfig.emptyString)
    }

    private func assignCuratedToSteps(_ resolved: [CuratedResolvedBook]) {
        var buckets: [[CuratedResolvedBook]] = [[], [], []]
        for r in resolved {
            let idx = max(0, min(2, r.curated.step - 1))
            buckets[idx].append(r)
        }
        curatedStepBooks = buckets
    }

    // MARK: - Extended Recommendations (확장 읽기)
    private func loadExtendedRecommendations(
        for philosopher: Philosopher,
        excluding curatedResolved: [CuratedResolvedBook]
    ) -> AnyPublisher<Void, Error> {
        let pages = Array(1...bestsellerPagesToScan)

        let curatedTitleKeys: Set<String> = Set(curatedResolved.map { normalize($0.title) })
        let curatedIsbnKeys: Set<String> = Set(curatedResolved.compactMap { $0.isbn13 }.map { normalize($0) })

        return Publishers.Sequence(sequence: pages)
            .flatMap(maxPublishers: .max(1)) { [api] page in
                api.fetch(.itemListBestseller(start: page, maxResults: self.pageSize))
                    .map { $0.item ?? [] }
                    .eraseToAnyPublisher()
            }
            .collect()
            .map { $0.flatMap { $0 } }
            .map { [weak self] allItems -> [BookItem] in
                guard let self else { return [] }

                // ✅ philosopher 고정값 사용
                let filtered = self.filterBestsellers(items: allItems, philosopher: philosopher)

                return filtered.filter { b in
                    let t = self.normalize(b.title ?? AppConfig.emptyString)
                    let isbn = self.normalize(b.isbn13 ?? b.isbn ?? AppConfig.emptyString)
                    if curatedTitleKeys.contains(t) { return false }
                    if !isbn.isEmpty, curatedIsbnKeys.contains(isbn) { return false }
                    return true
                }
            }
            .map { [weak self] items -> [[BookItem]] in
                guard let self else { return [[], [], []] }
                return self.assignExtendedToSteps(items, philosopher: philosopher) // ✅
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] buckets in
                self?.extendedStepBooks = buckets
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }


    private func filterBestsellers(items: [BookItem], philosopher: Philosopher) -> [BookItem] {
        let tokens = philosopher.filterTokens.map { $0.lowercased() }

        func haystack(_ b: BookItem) -> String {
            let parts = [b.author, b.title, b.description].compactMap { $0 }
            return parts.joined(separator: AppConfig.normalizeSpace).lowercased()
        }

        var out: [BookItem] = []
        for b in items {
            let h = haystack(b)
            if tokens.contains(where: { h.contains($0.lowercased()) }) {
                out.append(b)
            }
            if out.count >= AppConfig.extendedRecommendationLimit { break } // 확장 추천은 적당히
        }
        return out
    }

    private func assignExtendedToSteps(_ books: [BookItem], philosopher: Philosopher) -> [[BookItem]] {
        var buckets: [[BookItem]] = [[], [], []]
        for b in books {
            let idx = StepClassifier.classify(book: b, philosopher: philosopher)
            buckets[idx].append(b)
        }
        let limitPerStep = AppConfig.limitPerStep
        return buckets.map { Array($0.prefix(limitPerStep)) }
    }
}
