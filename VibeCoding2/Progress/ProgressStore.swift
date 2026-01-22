import Foundation
import CoreData
import Combine

/// Stores completion state ("완독 체크") for roadmap books.
@MainActor
final class ProgressStore: ObservableObject {
    private let stack: CoreDataStack
    private var ctx: NSManagedObjectContext { stack.container.viewContext }

    @Published private(set) var completedKeys: Set<String> = []

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
        refresh()
    }

    func refresh() {
        let req = NSFetchRequest<BookProgress>(entityName: BookProgress.entityName)
        req.predicate = NSPredicate(format: "isCompleted == YES")
        do {
            let items = try ctx.fetch(req)
            completedKeys = Set(items.map { $0.bookKey })
        } catch {
            // keep in-memory state as-is
        }
    }

    func isCompleted(bookKey: String) -> Bool {
        completedKeys.contains(bookKey)
    }

    func completedCount(authorId: String, stepId: String) -> Int {
        let req = NSFetchRequest<BookProgress>(entityName: BookProgress.entityName)
        req.predicate = NSPredicate(format: "authorId == %@ AND stepId == %@ AND isCompleted == YES", authorId, stepId)
        do { return try ctx.count(for: req) } catch { return 0 }
    }

func completedCount(authorId: String) -> Int {
        let req = NSFetchRequest<BookProgress>(entityName: BookProgress.entityName)
        req.predicate = NSPredicate(format: "authorId == %@ AND isCompleted == YES", authorId)
        do { return try ctx.count(for: req) } catch { return 0 }
    }

    func toggleCompleted(book: BookUIModel, authorId: String? = nil, stepId: String? = nil) {
        let key = ProgressStore.bookKey(for: book)
        var newCompleted = true
        if let existing = fetch(by: key) {
            existing.isCompleted.toggle()
            newCompleted = existing.isCompleted
            existing.completedAt = existing.isCompleted ? Date() : nil
            // Only overwrite context when provided (so Search/Favorites doesn't erase roadmap context).
            if let authorId { existing.authorId = authorId }
            if let stepId { existing.stepId = stepId }
            existing.title = book.title
            existing.author = book.author
            existing.isbn13 = book.isbn13.isEmpty ? nil : book.isbn13
        } else {
            let obj = BookProgress(context: ctx)
            obj.bookKey = key
            obj.isbn13 = book.isbn13.isEmpty ? nil : book.isbn13
            obj.title = book.title
            obj.author = book.author
            obj.authorId = authorId ?? "unknown"
            obj.stepId = stepId ?? "unknown"
            obj.isCompleted = true
            obj.completedAt = Date()
        }

        stack.saveIfNeeded()
        if newCompleted { completedKeys.insert(key) } else { completedKeys.remove(key) }
    }
    private func fetch(by bookKey: String) -> BookProgress? {
        let req = NSFetchRequest<BookProgress>(entityName: BookProgress.entityName)
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "bookKey == %@", bookKey)
        return (try? ctx.fetch(req))?.first
    }

    static func bookKey(for book: BookUIModel) -> String {
        if !book.isbn13.isEmpty { return "isbn13:\(book.isbn13)" }
        return "id:\(book.id)"
    }
}
