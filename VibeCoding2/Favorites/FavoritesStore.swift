import Foundation
import CoreData
import Combine

final class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: [FavoriteBook] = []

    private let stack: CoreDataStack
    private var cancellables = Set<AnyCancellable>()

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
        reload()

        // Observe context saves (simple refresh)
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: stack.container.viewContext)
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.reload() }
            .store(in: &cancellables)
    }

    func reload() {
        let ctx = stack.container.viewContext
        do {
            favorites = try ctx.fetch(FavoriteBook.fetchAll())
        } catch {
            favorites = []
        }
    }

    func isFavorited(bookId: String) -> Bool {
        favorites.contains { $0.id == bookId }
    }

    func toggle(book: BookUIModel) {
        let ctx = stack.container.viewContext
        if let existing = favorites.first(where: { $0.id == book.id }) {
            ctx.delete(existing)
            stack.saveIfNeeded()
            return
        }

        let fav = FavoriteBook(context: ctx)
        fav.id = book.id
        fav.title = book.title
        fav.author = book.author
        fav.summary = book.description
        fav.coverURL = book.coverURL?.absoluteString
        fav.linkURL = book.linkURL?.absoluteString
        fav.isbn13 = book.isbn13
        fav.createdAt = Date()

        stack.saveIfNeeded()
    }
}
