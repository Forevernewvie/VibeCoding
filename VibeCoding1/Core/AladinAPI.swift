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
        case .itemSearch: return AppConfig.aladinPathItemSearch
        case .itemListBestseller: return AppConfig.aladinPathItemList
        }
    }

    func url() -> URL {
        // 프록시 모드에서는 /aladin/<path>?... 형태로 통일
        // (Node/Worker 샘플도 동일)
        let base = AppConfig.baseURL
        let fullBase = AppConfig.useProxy ? base.appendingPathComponent(AppConfig.aladinProxyPrefix).appendingPathComponent(path)
                                         : base.appendingPathComponent(path)

        var comps = URLComponents(url: fullBase, resolvingAgainstBaseURL: false)!
        var q: [URLQueryItem] = []

        // 공통
        q.append(.init(name: AppConfig.aladinQueryItemOutput, value: AppConfig.output))
        q.append(.init(name: AppConfig.aladinQueryItemVersion, value: AppConfig.apiVersion))

        // 원본 알라딘 직접 호출 시만 key 포함
        if !AppConfig.useProxy {
            q.append(.init(name: AppConfig.aladinQueryItemTtbKey, value: AppConfig.ttbKeyForDev))
        }

        switch self {
        case let .itemSearch(query, queryType, start, maxResults):
            q.append(.init(name: AppConfig.aladinQueryItemQuery, value: query))
            q.append(.init(name: AppConfig.aladinQueryItemQueryType, value: queryType))
            q.append(.init(name: AppConfig.aladinQueryItemSearchTarget, value: AppConfig.aladinSearchTargetBook))
            q.append(.init(name: AppConfig.aladinQueryItemStart, value: String(start)))
            q.append(.init(name: AppConfig.aladinQueryItemMaxResults, value: String(maxResults)))

        case let .itemListBestseller(start, maxResults):
            q.append(.init(name: AppConfig.aladinQueryItemQueryType, value: AppConfig.aladinQueryTypeBestseller))
            q.append(.init(name: AppConfig.aladinQueryItemSearchTarget, value: AppConfig.aladinSearchTargetBook))
            q.append(.init(name: AppConfig.aladinQueryItemStart, value: String(start)))
            q.append(.init(name: AppConfig.aladinQueryItemMaxResults, value: String(maxResults)))
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
