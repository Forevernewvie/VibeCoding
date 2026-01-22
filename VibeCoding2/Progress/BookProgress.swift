import Foundation
import CoreData

@objc(BookProgress)
final class BookProgress: NSManagedObject {
    static let entityName = "BookProgress"

    @NSManaged var bookKey: String
    @NSManaged var isbn13: String?
    @NSManaged var title: String
    @NSManaged var author: String
    @NSManaged var authorId: String
    @NSManaged var stepId: String
    @NSManaged var isCompleted: Bool
    @NSManaged var completedAt: Date?
}
