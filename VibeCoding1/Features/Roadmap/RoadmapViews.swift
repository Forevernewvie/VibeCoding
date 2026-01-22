import SwiftUI

struct RoadmapRootView: View {
    @StateObject private var vm = RoadmapViewModel()
    @EnvironmentObject private var appState: AppState

    @State private var expandedStepIDs: Set<UUID> = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerCard
                    philosopherPicker
                    roadmapTimeline
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("철학사 로드맵")
        }
        .onAppear {
            if let first = vm.steps.first { expandedStepIDs.insert(first.id) }
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("고대 → 중세 -> 근대 -> 19세기")
                .font(.system(.title2, design: .serif).weight(.semibold))

            Text("추천은 ‘정답 로드맵(필독)’을 먼저 깔고, 알라딘은 표지/가격/링크를 보강합니다.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Label("필독 추천", systemImage: "checkmark.seal")
                Label("확장 읽기", systemImage: "sparkles")
                Spacer()
                if vm.isLoading { ProgressView().scaleEffect(0.9) }
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 10, y: 6)
    }

    private var philosopherPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("철학자")
                .font(.headline)

            let ancient = Philosopher.allCases.filter { $0.era == "고대 철학" }
            let medieval = Philosopher.allCases.filter { $0.era == "중세 철학" }
            let modern = Philosopher.allCases.filter { $0.era == "근대 철학" }
            let nineteenth = Philosopher.allCases.filter { $0.era == "19세기 철학" }

            VStack(spacing: 10) {
                groupRow(title: "고대", items: ancient)
                groupRow(title: "중세", items: medieval)
                groupRow(title: "근대", items: modern)
                groupRow(title: "19세기", items: nineteenth)
            }
        }
        .padding(14)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 10, y: 6)
    }

    private func groupRow(title: String, items: [Philosopher]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(items) { p in
                    Button {
                        vm.selected = p
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(p.rawValue)
                                .font(.system(.headline, design: .rounded))
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(p.blurb)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(12)
                        .background(vm.selected == p ? Color.indigo.opacity(0.14) : Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(vm.selected == p ? Color.indigo.opacity(0.55) : Color.clear, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var roadmapTimeline: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(vm.selected.rawValue) 로드맵")
                    .font(.headline)
                Spacer()
                if let msg = vm.errorMessage {
                    Text("오류")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .help(msg)
                }
            }

            ForEach(Array(vm.steps.enumerated()), id: \.element.id) { idx, step in
                timelineRow(index: idx, step: step)
            }
        }
        .padding(14)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 10, y: 6)
    }

    private func stepSearchQuery(stepIndex: Int) -> String {
        let base = vm.selected.authorQuery
        switch vm.selected {
        case .plato:
            return base + " " + (stepIndex == 0 ? "대화편" : stepIndex == 1 ? "국가" : "티마이오스")
        case .aristotle:
            return base + " " + (stepIndex == 0 ? "윤리" : stepIndex == 1 ? "논리" : "형이상학")
        case .augustine:
            return base + " " + (stepIndex == 0 ? "고백록" : stepIndex == 1 ? "신국론" : "삼위일체")
        case .anselm:
            return base + " " + (stepIndex == 0 ? "프로슬로기온" : stepIndex == 1 ? "존재논증" : "Cur Deus Homo")
        case .aquinas:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "신학대전" : "주석")

        case .boethius:
            return base + " " + (stepIndex == 0 ? "철학의 위안" : stepIndex == 1 ? "신학" : "선집")
        case .avicenna:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "형이상학" : "치유의 서")
        case .averroes:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "주석" : "아리스토텔레스")
        case .dunsScotus:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "형이상학" : "강해")
        case .ockham:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "논리학" : "명목론")

        case .descartes:
            return base + " " + (stepIndex == 0 ? "방법서설" : stepIndex == 1 ? "성찰" : "정념론")
        case .spinoza:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "윤리학" : "신학정치론")
        case .locke:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "인간오성" : "정부론")
        case .leibniz:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "단자론" : "신정론")
        case .hume:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "인성론" : "탐구")
        case .rousseau:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "사회계약론" : "에밀")
        case .kant:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "순수이성비판" : "실천이성비판")

        case .marx:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "공산당 선언" : "자본")
        case .hegel:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "정신현상학" : "법철학")
        case .nietzsche:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "차라투스트라" : "도덕의 계보")
        case .kierkegaard:
            return base + " " + (stepIndex == 0 ? "입문" : stepIndex == 1 ? "죽음에 이르는 병" : "불안의 개념")
        }
    }

    private func timelineRow(index: Int, step: RoadmapStep) -> some View {
        let curated = vm.curatedStepBooks[safe: index] ?? []
        let extended = vm.extendedStepBooks[safe: index] ?? []

        return HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 6) {
                Circle().fill(.indigo).frame(width: 10, height: 10)
                if index < (vm.steps.count - 1) {
                    Rectangle().fill(.indigo.opacity(0.25))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 14)

            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(step.title)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    Text(step.subtitle)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedStepIDs.contains(step.id) },
                        set: { newValue in
                            if newValue { expandedStepIDs.insert(step.id) }
                            else { expandedStepIDs.remove(step.id) }
                        }
                    )
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        // 필독 추천(큐레이션) — 항상 존재
                        VStack(alignment: .leading, spacing: 8) {
                            Text("필독 추천")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)

                            ForEach(curated) { b in
                                CuratedRow(b: b)
                            }
                        }

                        // 확장 읽기(베스트셀러) — 존재할 때만
                        if !extended.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("확장 읽기")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)

                                ForEach(extended) { book in
                                    if let link = book.link, let url = URL(string: link) {
                                        Link(destination: url) {
                                            HStack(spacing: 10) {
                                                VStack(alignment: .leading, spacing: 3) {
                                                    Text(book.title ?? "제목 없음")
                                                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                                                        .foregroundStyle(.primary)
                                                        .lineLimit(2)

                                                    Text(book.author ?? "")
                                                        .font(.caption)
                                                        .foregroundStyle(.secondary)
                                                        .lineLimit(1)
                                                }
                                                Spacer()
                                                Image(systemName: "arrow.up.right.square")
                                                    .foregroundStyle(.secondary)
                                            }
                                            .padding(10)
                                            .background(Color(.secondarySystemBackground))
                                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        Button {
                            let q = stepSearchQuery(stepIndex: index)
                            appState.openSearch(with: q)
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "magnifyingglass")
                                Text("검색에서 더보기")
                            }
                            .font(.caption.weight(.semibold))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.indigo.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 6)
                } label: {
                    HStack {
                        Text("펼쳐보기")
                        Spacer()
                        Text("필독 \(curated.count) · 확장 \(extended.count)")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                }
                .padding(12)
                .background(Color.indigo.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(.vertical, 6)
    }
}

private struct CuratedRow: View {
    let b: CuratedResolvedBook

    var body: some View {
        Group {
            if let link = b.link, let url = URL(string: link) {
                Link(destination: url) { content }
            } else {
                content
            }
        }
        .buttonStyle(.plain)
    }

    private var content: some View {
        HStack(alignment: .top, spacing: 10) {
            if let cover = b.cover, let url = URL(string: cover) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12))
                            .frame(width: 44, height: 60)
                    case .success(let img):
                        img.resizable().scaledToFill()
                            .frame(width: 44, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    case .failure:
                        RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12))
                            .overlay(Image(systemName: "book").foregroundStyle(.secondary))
                            .frame(width: 44, height: 60)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12))
                    .overlay(Image(systemName: "checkmark.seal").foregroundStyle(.secondary))
                    .frame(width: 44, height: 60)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(b.curated.title)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text(b.curated.author)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(b.curated.reason)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)

                if let sales = b.priceSales {
                    Text("할인가 \(sales)원")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.indigo)
                }
            }

            Spacer()

            Image(systemName: b.link == nil ? "questionmark.circle" : "arrow.up.right.square")
                .foregroundStyle(.secondary)
                .padding(.top, 2)
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
