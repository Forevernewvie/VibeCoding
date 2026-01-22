import Foundation

// 알라딘 검색/리스트 공통 응답
struct AladinResponse: Codable {
    let title: String?
    let link: String?
    let totalResults: Int?
    let startIndex: Int?
    let itemsPerPage: Int?
    let item: [BookItem]?
}

struct BookItem: Codable, Identifiable, Hashable {
    let itemId: Int?
    var id: String { String(itemId ?? Int.random(in: 1...Int.max)) }

    let title: String?
    let link: String?
    let author: String?
    let publisher: String?

    let isbn: String?
    let isbn13: String?

    let cover: String?

    let priceStandard: Int?
    let priceSales: Int?

    let description: String?

    enum CodingKeys: String, CodingKey {
        case itemId, title, link, author, publisher
        case isbn, isbn13
        case cover
        case priceStandard, priceSales
        case description
    }
}


/// 큐레이션(필독) + 알라딘 매칭(선택) 결합 모델
struct CuratedResolvedBook: Identifiable, Hashable {
    let id: UUID
    let curated: CuratedBook
    let matched: BookItem?

    init(curated: CuratedBook, matched: BookItem?) {
        self.id = curated.id
        self.curated = curated
        self.matched = matched
    }

    var title: String { matched?.title ?? curated.title }
    var author: String { matched?.author ?? curated.author }
    var link: String? { matched?.link }
    var cover: String? { matched?.cover }
    var isbn13: String? { matched?.isbn13 ?? matched?.isbn }
    var priceStandard: Int? { matched?.priceStandard }
    var priceSales: Int? { matched?.priceSales }
    var description: String? { matched?.description }
}
