import Foundation

/// UI-friendly model derived from AladinBookItem (network) or Favorite (local).
struct BookUIModel: Identifiable, Hashable {
    let id: String
    let title: String
    let author: String
    let description: String
    let coverURL: URL?
    let linkURL: URL?
    let isbn13: String



    init(id: String, title: String, author: String, description: String, coverURL: URL?, linkURL: URL?, isbn13: String) {
        self.id = id
        self.title = title
        self.author = author
        self.description = description
        self.coverURL = coverURL
        self.linkURL = linkURL
        self.isbn13 = isbn13
    }

    init(from item: AladinBookItem) {
        let itemId = item.itemId.map(String.init) ?? "0"
        let isbn = item.isbn13 ?? ""
        self.id = itemId + "-" + isbn
        self.title = item.title ?? "(제목 없음)"
        self.author = item.author ?? "(저자 없음)"
        self.description = item.description ?? ""
        self.coverURL = URL(string: item.cover ?? "")
        self.linkURL = URL(string: item.link ?? "")
        self.isbn13 = isbn
    }
}
