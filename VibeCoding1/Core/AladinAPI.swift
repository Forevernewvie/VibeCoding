import Foundation
import Combine

/// 프록시 사용 시:
/// - 앱은 `path`와 나머지 쿼리만 전달
/// - 프록시가 `ttbkey`를 서버에서만 주입
enum AladinEndpoint {
    case itemSearch(query: String, queryType: String, start: Int, maxResults: Int)
    case itemListBestseller(start: Int, maxResults: Int)

    var path: String {
        switch self {
        case .itemSearch: return "ItemSearch.aspx"
        case .itemListBestseller: return "ItemList.aspx"
        }
    }

    func url() -> URL {
        // 프록시 모드에서는 /aladin/<path>?... 형태로 통일
        // (Node/Worker 샘플도 동일)
        let base = AppConfig.baseURL
        let fullBase = AppConfig.useProxy ? base.appendingPathComponent("aladin").appendingPathComponent(path)
                                         : base.appendingPathComponent(path)

        var comps = URLComponents(url: fullBase, resolvingAgainstBaseURL: false)!
        var q: [URLQueryItem] = []

        // 공통
        q.append(.init(name: "output", value: AppConfig.output))
        q.append(.init(name: "Version", value: AppConfig.apiVersion))

        // 원본 알라딘 직접 호출 시만 key 포함
        if !AppConfig.useProxy {
            q.append(.init(name: "ttbkey", value: AppConfig.ttbKeyForDev))
        }

        switch self {
        case let .itemSearch(query, queryType, start, maxResults):
            q.append(.init(name: "Query", value: query))
            q.append(.init(name: "QueryType", value: queryType))      // Title / Author / Keyword / ISBN ...
            q.append(.init(name: "SearchTarget", value: "Book"))
            q.append(.init(name: "start", value: String(start)))      // 페이지 (1부터)
            q.append(.init(name: "MaxResults", value: String(maxResults)))

        case let .itemListBestseller(start, maxResults):
            q.append(.init(name: "QueryType", value: "Bestseller"))
            q.append(.init(name: "SearchTarget", value: "Book"))
            q.append(.init(name: "start", value: String(start)))
            q.append(.init(name: "MaxResults", value: String(maxResults)))
        }

        comps.queryItems = q
        return comps.url!
    }
}

protocol AladinServicing {
    func fetch(_ endpoint: AladinEndpoint) -> AnyPublisher<AladinResponse, Error>
}

final class AladinAPI: AladinServicing {
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }

    func fetch(_ endpoint: AladinEndpoint) -> AnyPublisher<AladinResponse, Error> {
        let url = endpoint.url()

        return session.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: AladinResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
