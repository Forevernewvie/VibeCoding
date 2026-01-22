import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = Self.makeModel()
        container = NSPersistentContainer(name: "LiteratureRoadmap", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("CoreData load failed: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveIfNeeded() {
        let ctx = container.viewContext
        guard ctx.hasChanges else { return }
        do {
            try ctx.save()
        } catch {
            assertionFailure("CoreData save failed: \(error)")
        }
    }

    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // FavoriteBook
        let favoriteEntity = NSEntityDescription()
        favoriteEntity.name = FavoriteBook.entityName
        favoriteEntity.managedObjectClassName = NSStringFromClass(FavoriteBook.self)

        func attr(_ name: String, _ type: NSAttributeType, optional: Bool = true) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = type
            a.isOptional = optional
            return a
        }

        favoriteEntity.properties = [
            attr("id", .stringAttributeType, optional: false),
            attr("title", .stringAttributeType, optional: false),
            attr("author", .stringAttributeType, optional: false),
            attr("summary", .stringAttributeType, optional: true),
            attr("coverURL", .stringAttributeType, optional: true),
            attr("linkURL", .stringAttributeType, optional: true),
            attr("isbn13", .stringAttributeType, optional: false),
            attr("createdAt", .dateAttributeType, optional: false)
        ]

        // Uniqueness constraint to avoid duplicates
        favoriteEntity.uniquenessConstraints = [["id"]]

        // BookProgress (완독 체크)
        let progressEntity = NSEntityDescription()
        progressEntity.name = BookProgress.entityName
        progressEntity.managedObjectClassName = NSStringFromClass(BookProgress.self)

        progressEntity.properties = [
            attr("bookKey", .stringAttributeType, optional: false),
            attr("isbn13", .stringAttributeType, optional: true),
            attr("title", .stringAttributeType, optional: false),
            attr("author", .stringAttributeType, optional: false),
            attr("authorId", .stringAttributeType, optional: false),
            attr("stepId", .stringAttributeType, optional: false),
            attr("isCompleted", .booleanAttributeType, optional: false),
            attr("completedAt", .dateAttributeType, optional: true)
        ]
        progressEntity.uniquenessConstraints = [["bookKey"]]

        model.entities = [favoriteEntity, progressEntity]
        return model
    }
}
