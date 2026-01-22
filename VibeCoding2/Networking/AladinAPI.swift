import Foundation
import Combine

/// Thin client for Aladin TTB OpenAPI.
/// Docs/Examples: ItemSearch / ItemLookUp, output=JS, Version=20131101. (Aladin OpenAPI 안내)
final class AladinAPI {
    static let shared = AladinAPI()

    private let base = URL(string: "https://www.aladin.co.kr/ttb/api/")!

    /// Provided by user
    private let ttbKey: String = "ttbcjb110551824001"

    private let version = "20131101"
    private let output = "JS"

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        return d
    }()

    enum APIError: LocalizedError {
        case badURL
        case empty

        var errorDescription: String? {
            switch self {
            case .badURL: return "요청 URL 생성에 실패했습니다."
            case .empty: return "결과가 없습니다."
            }
        }
    }

    func searchBooks(query: String, start: Int, maxResults: Int = 30) -> AnyPublisher<AladinItemSearchResponse, Error> {
        var items: [URLQueryItem] = [
            .init(name: "ttbkey", value: ttbKey),
            .init(name: "Query", value: query),
            .init(name: "QueryType", value: "Keyword"),
            .init(name: "MaxResults", value: String(maxResults)),
            .init(name: "start", value: String(start)),
            .init(name: "SearchTarget", value: "Book"),
            .init(name: "output", value: output),
            .init(name: "Version", value: version)
        ]

        // Keep it simple: request only basic info; the link field is what we need for outbound navigation.
        // (Aladin supports OptResult, but it is optional.)
        let url = makeURL(path: "ItemSearch.aspx", queryItems: items)

        guard let url else { return Fail(error: APIError.badURL).eraseToAnyPublisher() }

        return ResponseCache.shared.dataPublisher(for: url)
            .decode(type: AladinItemSearchResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    /// Convenience: for roadmap seeds, we search using "title author" and pick the first hit.
    func searchTopOne(query: String) -> AnyPublisher<AladinBookItem, Error> {
        searchBooks(query: query, start: 1, maxResults: 1)
            .tryMap { resp in
                guard let first = resp.item?.first else { throw APIError.empty }
                return first
            }
            .eraseToAnyPublisher()
    }

    private func makeURL(path: String, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(url: base.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        return components?.url
    }
}
