import Foundation
import CoreData

@objc(FavoriteBook)
final class FavoriteBook: NSManagedObject {
    static let entityName = "FavoriteBook"

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var author: String
    @NSManaged var summary: String?
    @NSManaged var coverURL: String?
    @NSManaged var linkURL: String?
    @NSManaged var isbn13: String
    @NSManaged var createdAt: Date
}

extension FavoriteBook {
    static func fetchAll() -> NSFetchRequest<FavoriteBook> {
        let req = NSFetchRequest<FavoriteBook>(entityName: entityName)
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return req
    }
}
