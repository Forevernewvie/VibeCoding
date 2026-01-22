import Foundation
import Combine

@MainActor
final class RoadmapViewModel: ObservableObject {
    // MARK: - Roadmap list (filter/sort)
    private let allAuthors: [RoadmapAuthor] = RoadmapSeeds.authors
    @Published private(set) var authors: [RoadmapAuthor] = RoadmapSeeds.authors

    enum SortOption: String, CaseIterable, Identifiable {
        case name = "이름"
        case era = "시대"
        case difficulty = "난이도"
        var id: String { rawValue }
    }

    @Published var selectedNationality: String? = nil
    @Published var selectedEra: String? = nil
    @Published var selectedDifficulty: RoadmapDifficulty? = nil
    @Published var sortOption: SortOption = .name
    @Published var sortAscending: Bool = true

    /// cache seedId -> loaded UI model
    @Published private(set) var bookCache: [String: BookUIModel] = [:]
    @Published private(set) var loadingSeedIds: Set<String> = []
    @Published var lastErrorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let api: AladinAPI

    init(api: AladinAPI = .shared) {
        self.api = api
        bindAuthorsPipeline()
    }

    private func bindAuthorsPipeline() {
        Publishers.CombineLatest4($selectedNationality, $selectedEra, $selectedDifficulty, $sortOption)
            .combineLatest($sortAscending)
            .map { [weak self] tuple, ascending -> [RoadmapAuthor] in
                guard let self else { return [] }
                let (nationality, era, difficulty, sort) = tuple

                var list = self.allAuthors
                if let nationality { list = list.filter { $0.nationality == nationality } }
                if let era { list = list.filter { $0.era == era } }
                if let difficulty { list = list.filter { $0.difficulty == difficulty } }

                func cmp<T: Comparable>(_ lhs: T, _ rhs: T) -> Bool { ascending ? (lhs < rhs) : (lhs > rhs) }

                list.sort { a, b in
                    switch sort {
                    case .name:
                        return cmp(a.name, b.name)
                    case .era:
                        return cmp(a.era, b.era)
                    case .difficulty:
                        return cmp(a.difficulty.sortOrder, b.difficulty.sortOrder)
                    }
                }
                return list
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.authors = $0 }
            .store(in: &cancellables)
    }

    var nationalities: [String] {
        Array(Set(allAuthors.map { $0.nationality })).sorted()
    }

    var eras: [String] {
        Array(Set(allAuthors.map { $0.era })).sorted()
    }

    func resetFilters() {
        selectedNationality = nil
        selectedEra = nil
        selectedDifficulty = nil
        sortOption = .name
        sortAscending = true
    }

    func loadIfNeeded(seed: BookSeed) {
        guard bookCache[seed.id] == nil else { return }
        guard !loadingSeedIds.contains(seed.id) else { return }
        loadingSeedIds.insert(seed.id)

        api.searchTopOne(query: seed.query)
            .map(BookUIModel.init(from:))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.loadingSeedIds.remove(seed.id)
                if case let .failure(error) = completion {
                    self.lastErrorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] book in
                self?.bookCache[seed.id] = book
            }
            .store(in: &cancellables)
    }
}
