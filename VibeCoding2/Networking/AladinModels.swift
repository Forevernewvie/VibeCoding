import Foundation

struct AladinItemSearchResponse: Codable {
    let totalResults: Int?
    let startIndex: Int?
    let itemsPerPage: Int?
    let item: [AladinBookItem]?
}

struct AladinBookItem: Codable, Hashable, Identifiable {
    typealias ID = String

    let itemId: Int?
    let title: String?
    let link: String?
    let author: String?
    let pubDate: String?
    let description: String?
    let isbn13: String?
    let cover: String?
    let categoryName: String?

    var id: String {
        let a = itemId.map(String.init) ?? "0"
        let b = isbn13 ?? ""
        return a + "-" + b
    }
}
