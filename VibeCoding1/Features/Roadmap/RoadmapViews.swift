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
            .navigationTitle(AppConfig.roadmapNavigationTitle)
        }
        .onAppear {
            if let first = vm.steps.first { expandedStepIDs.insert(first.id) }
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppConfig.roadmapHeaderTitle)
                .font(.system(.title2, design: .serif).weight(.semibold))

            Text(AppConfig.roadmapHeaderSubtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Label(AppConfig.curatedRecommendation, systemImage: "checkmark.seal")
                Label(AppConfig.extendedReading, systemImage: "sparkles")
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
            Text(AppConfig.philosopherTitle)
                .font(.headline)

            let ancient = Philosopher.allCases.filter { $0.era == AppConfig.eraAncientPhilosophy }
            let medieval = Philosopher.allCases.filter { $0.era == AppConfig.eraMedievalPhilosophy }
            let modern = Philosopher.allCases.filter { $0.era == AppConfig.eraModernPhilosophy }
            let nineteenth = Philosopher.allCases.filter { $0.era == AppConfig.eraNineteenthPhilosophy }

            VStack(spacing: 10) {
                groupRow(title: AppConfig.eraAncient, items: ancient)
                groupRow(title: AppConfig.eraMedieval, items: medieval)
                groupRow(title: AppConfig.eraModern, items: modern)
                groupRow(title: AppConfig.eraNineteenth, items: nineteenth)
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
                Text("\(vm.selected.rawValue)\(AppConfig.roadmapSuffix)")
                    .font(.headline)
                Spacer()
                if let msg = vm.errorMessage {
                    Text(AppConfig.errorText)
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
            return base + " " + (stepIndex == 0 ? AppConfig.platoDialogue : stepIndex == 1 ? AppConfig.platoRepublic : AppConfig.platoTimaeus)
        case .aristotle:
            return base + " " + (stepIndex == 0 ? AppConfig.aristotleEthics : stepIndex == 1 ? AppConfig.aristotleLogic : AppConfig.aristotleMetaphysics)
        case .augustine:
            return base + " " + (stepIndex == 0 ? AppConfig.augustineConfessions : stepIndex == 1 ? AppConfig.augustineCityOfGod : AppConfig.augustineTrinity)
        case .anselm:
            return base + " " + (stepIndex == 0 ? AppConfig.anselmProslogion : stepIndex == 1 ? AppConfig.anselmOntologicalArgument : AppConfig.anselmCurDeusHomo)
        case .aquinas:
            return base + " " + (stepIndex == 0 ? AppConfig.aquinasIntroduction : stepIndex == 1 ? AppConfig.aquinasSummaTheologica : AppConfig.aquinasCommentary)

        case .boethius:
            return base + " " + (stepIndex == 0 ? AppConfig.boethiusConsolation : stepIndex == 1 ? AppConfig.boethiusTheology : AppConfig.boethiusAnthology)
        case .avicenna:
            return base + " " + (stepIndex == 0 ? AppConfig.avicennaIntroduction : stepIndex == 1 ? AppConfig.avicennaMetaphysics : AppConfig.avicennaBookOfHealing)
        case .averroes:
            return base + " " + (stepIndex == 0 ? AppConfig.averroesIntroduction : stepIndex == 1 ? AppConfig.averroesCommentary : AppConfig.averroesAristotle)
        case .dunsScotus:
            return base + " " + (stepIndex == 0 ? AppConfig.dunsScotusIntroduction : stepIndex == 1 ? AppConfig.dunsScotusMetaphysics : AppConfig.dunsScotusLectures)
        case .ockham:
            return base + " " + (stepIndex == 0 ? AppConfig.ockhamIntroduction : stepIndex == 1 ? AppConfig.ockhamLogic : AppConfig.ockhamNominalism)

        case .descartes:
            return base + " " + (stepIndex == 0 ? AppConfig.descartesDiscourse : stepIndex == 1 ? AppConfig.descartesMeditations : AppConfig.descartesPassions)
        case .spinoza:
            return base + " " + (stepIndex == 0 ? AppConfig.spinozaIntroduction : stepIndex == 1 ? AppConfig.spinozaEthics : AppConfig.spinozaTheologicoPolitical)
        case .locke:
            return base + " " + (stepIndex == 0 ? AppConfig.lockeIntroduction : stepIndex == 1 ? AppConfig.lockeHumanUnderstanding : AppConfig.lockeGovernment)
        case .leibniz:
            return base + " " + (stepIndex == 0 ? AppConfig.leibnizIntroduction : stepIndex == 1 ? AppConfig.leibnizMonadology : AppConfig.leibnizTheodicy)
        case .hume:
            return base + " " + (stepIndex == 0 ? AppConfig.humeIntroduction : stepIndex == 1 ? AppConfig.humeHumanNature : AppConfig.humeEnquiry)
        case .rousseau:
            return base + " " + (stepIndex == 0 ? AppConfig.rousseauIntroduction : stepIndex == 1 ? AppConfig.rousseauSocialContract : AppConfig.rousseauEmile)
        case .kant:
            return base + " " + (stepIndex == 0 ? AppConfig.kantIntroduction : stepIndex == 1 ? AppConfig.kantPureReason : AppConfig.kantPracticalReason)

        case .marx:
            return base + " " + (stepIndex == 0 ? AppConfig.marxIntroduction : stepIndex == 1 ? AppConfig.marxCommunistManifesto : AppConfig.marxCapital)
        case .hegel:
            return base + " " + (stepIndex == 0 ? AppConfig.hegelIntroduction : stepIndex == 1 ? AppConfig.hegelPhenomenology : AppConfig.hegelPhilosophyOfRight)
        case .nietzsche:
            return base + " " + (stepIndex == 0 ? AppConfig.nietzscheIntroduction : stepIndex == 1 ? AppConfig.nietzscheZarathustra : AppConfig.nietzscheGenealogyOfMorality)
        case .kierkegaard:
            return base + " " + (stepIndex == 0 ? AppConfig.kierkegaardIntroduction : stepIndex == 1 ? AppConfig.kierkegaardSicknessUntoDeath : AppConfig.kierkegaardConceptOfAnxiety)
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
                            Text(AppConfig.curatedRecommendation)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)

                            ForEach(curated) { b in
                                CuratedRow(b: b)
                            }
                        }

                        // 확장 읽기(베스트셀러) — 존재할 때만
                        if !extended.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(AppConfig.extendedReading)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)

                                ForEach(extended) { book in
                                    if let link = book.link, let url = URL(string: link) {
                                        Link(destination: url) {
                                            HStack(spacing: 10) {
                                                VStack(alignment: .leading, spacing: 3) {
                                                    Text(book.title ?? AppConfig.noTitle)
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
                                Text(AppConfig.searchMoreText)
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
                        Text(AppConfig.expandText)
                        Spacer()
                        Text("\(AppConfig.curatedCountPrefix)\(curated.count)\(AppConfig.extendedCountPrefix)\(extended.count)")
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
                    Text("\(AppConfig.priceSalesPrefix)\(sales)\(AppConfig.priceSuffix)")
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
