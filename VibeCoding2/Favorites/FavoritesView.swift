import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var progress: ProgressStore

    @State private var safariURL: URL?

    var body: some View {
        NavigationStack {
            Group {
                if favorites.favorites.isEmpty {
                    ContentUnavailableView("아직 즐겨찾기가 없어요", systemImage: "heart", description: Text("로드맵 또는 검색에서 하트 버튼을 눌러 저장해주세요."))
                } else {
                    List {
                        ForEach(favorites.favorites, id: \.id) { fav in
                            let book = BookUIModel(
                                id: fav.id,
                                title: fav.title,
                                author: fav.author,
                                description: fav.summary ?? "",
                                coverURL: URL(string: fav.coverURL ?? ""),
                                linkURL: URL(string: fav.linkURL ?? ""),
                                isbn13: fav.isbn13
                            )
                            BookRowView(
                                book: book,
                                subtitle: "즐겨찾기",
                                onTap: {
                                    if let url = book.linkURL { safariURL = url }
                                },
                                onToggleFavorite: { favorites.toggle(book: book) },
                                isFavorited: favorites.isFavorited(bookId: book.id),
                                onToggleCompleted: {
                                    progress.toggleCompleted(book: book)
                                },
                                isCompleted: progress.isCompleted(bookKey: ProgressStore.bookKey(for: book))
                            )
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("즐겨찾기")
        }
        .sheet(item: $safariURL) { url in
            SafariView(url: url)
        }
    }
}
