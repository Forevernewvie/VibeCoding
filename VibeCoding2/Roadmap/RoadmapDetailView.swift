import SwiftUI

struct RoadmapDetailView: View {
    let author: RoadmapAuthor

    @EnvironmentObject private var vm: RoadmapViewModel
    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var progress: ProgressStore

    @State private var safariURL: URL?

    private var totalBooks: Int {
        author.steps.reduce(0) { $0 + $1.books.count }
    }

    private var completedBooks: Int {
        progress.completedCount(authorId: author.id)
    }

    private var completionFraction: Double {
        guard totalBooks > 0 else { return 0 }
        return Double(completedBooks) / Double(totalBooks)
    }

    var body: some View {
        List {
            Section {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                    Text(author.name)
                        .font(.title2.bold())
                    Text("\(author.nationality) · \(author.era)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(author.tagline)
                        .font(.body)
                        .foregroundStyle(.primary)

                    Text("완독 \(completedBooks)/\(totalBooks)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                    Spacer(minLength: 8)

                    ProgressRingView(fraction: completionFraction)
                        .padding(.top, 2)
                }
                .padding(.vertical, 8)
            }

            ForEach(author.steps) { step in
                Section {
                    ForEach(step.books) { seed in
                        StepBookRow(seed: seed, authorId: author.id, stepId: step.id, stepTitle: step.title, safariURL: $safariURL)
                    }
                } header: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                        Text(step.purpose)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        // progress summary
                        Text("완독 \(progress.completedCount(authorId: author.id, stepId: step.id))/\(step.books.count)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("로드맵")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $safariURL) { url in
            SafariView(url: url)
        }
    }

    private struct StepBookRow: View {
        let seed: BookSeed
        let authorId: String
        let stepId: String
        let stepTitle: String
        @Binding var safariURL: URL?

        @EnvironmentObject private var vm: RoadmapViewModel
        @EnvironmentObject private var favorites: FavoritesStore
        @EnvironmentObject private var progress: ProgressStore

        var body: some View {
            Group {
                if let book = vm.bookCache[seed.id] {
                    BookRowView(
                        book: book,
                        subtitle: seed.why,
                        onTap: { if let url = book.linkURL { safariURL = url } },
                        onToggleFavorite: { favorites.toggle(book: book) },
                        isFavorited: favorites.isFavorited(bookId: book.id),
                        onToggleCompleted: { progress.toggleCompleted(book: book, authorId: authorId, stepId: stepId) },
                        isCompleted: progress.isCompleted(bookKey: ProgressStore.bookKey(for: book))
                    )
                } else {
                    // Placeholder row
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.quaternary)
                            .frame(width: 54, height: 72)
                            .overlay {
                                if vm.loadingSeedIds.contains(seed.id) {
                                    ProgressView()
                                }
                            }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(seed.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(seed.author)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(seed.why)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        vm.loadIfNeeded(seed: seed)
                    }
                    .task {
                        vm.loadIfNeeded(seed: seed)
                    }
                }
            }
            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
        }
    }
}

private struct URLIdent: Identifiable {
    let id = UUID()
    let url: URL
}
