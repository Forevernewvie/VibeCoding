import Foundation
import Combine

@MainActor
final class BookSearchViewModel: ObservableObject {
    @Published var query: String = AppConfig.defaultQuery
    @Published var results: [BookItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api: AladinServicing
    private var bag = Set<AnyCancellable>()

    private var currentPage: Int = 1
    internal var canLoadMore: Bool = true
    private var lastIssuedQuery: String = ""

    init(api: AladinServicing = AladinAPI()) {
        self.api = api
    }

    func search(reset: Bool = true) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if reset {
            currentPage = 1
            canLoadMore = true
            results = []
            lastIssuedQuery = trimmed
        }

        guard canLoadMore, !isLoading else { return }

        isLoading = true
        errorMessage = nil

        api.fetch(.itemSearch(query: trimmed, queryType: AppConfig.aladinQueryTypeKeyword, start: currentPage, maxResults: AppConfig.aladinMaxResults))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] resp in
                guard let self else { return }
                let newItems = resp.item ?? []
                self.results.append(contentsOf: newItems)

                if newItems.count < AppConfig.aladinMaxResults { self.canLoadMore = false }
                else { self.currentPage += 1 }
            }
            .store(in: &bag)
    }

    func loadMoreIfNeeded(current item: BookItem) {
        guard item == results.last else { return }
        guard query.trimmingCharacters(in: .whitespacesAndNewlines) == lastIssuedQuery else { return }
        search(reset: false)
    }
}
