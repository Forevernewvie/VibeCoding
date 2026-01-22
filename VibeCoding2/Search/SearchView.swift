import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var vm: SearchViewModel
    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var progress: ProgressStore

    @State private var safariURL: URL?

    var body: some View {
        NavigationStack {
            Group {
                if vm.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ContentUnavailableView("검색어를 입력해 주세요", systemImage: "magnifyingglass", description: Text("예: 도스토예프스키, 죄와 벌"))
                } else if vm.isLoading && vm.items.isEmpty {
                    ProgressView("검색 중…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let msg = vm.errorMessage, vm.items.isEmpty {
                    ContentUnavailableView("검색 실패", systemImage: "exclamationmark.triangle", description: Text(msg))
                } else if vm.items.isEmpty {
                    ContentUnavailableView("결과 없음", systemImage: "books.vertical", description: Text("다른 키워드를 시도해 보세요"))
                } else {
                    List {
                        ForEach(vm.items) { book in
                            BookRowView(
                                book: book,
                                subtitle: book.author,
                                onTap: {
                                    safariURL = book.linkURL
                                },
                                onToggleFavorite: {
                                    favorites.toggle(book: book)
                                },
                                isFavorited: favorites.isFavorited(bookId: book.id),
                                onToggleCompleted: {
                                    progress.toggleCompleted(book: book)
                                },
                                isCompleted: progress.isCompleted(bookKey: ProgressStore.bookKey(for: book))
                            )
                            .onAppear {
                                vm.loadMoreIfNeeded(currentItem: book)
                            }
                        }

                        if vm.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("검색")
            .searchable(text: $vm.query, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "제목·저자·키워드")
        }
        .sheet(item: $safariURL) { url in
            SafariView(url: url)
        }
    }
}
