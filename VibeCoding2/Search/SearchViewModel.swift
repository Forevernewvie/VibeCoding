import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var items: [BookUIModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    private var cancellables = Set<AnyCancellable>()
    private let api: AladinAPI

    init(api: AladinAPI = .shared) {
        self.api = api

        $query
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                if text.isEmpty {
                    self.items = []
                    self.errorMessage = nil
                    self.currentPage = 1
                    self.canLoadMore = true
                } else {
                    self.search(reset: true)
                }
            }
            .store(in: &cancellables)
    }

    func search(reset: Bool) {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }

        if reset {
            currentPage = 1
            canLoadMore = true
            items = []
        }

        guard !isLoading, canLoadMore else { return }

        isLoading = true
        errorMessage = nil

        api.searchBooks(query: q, start: currentPage, maxResults: 30)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                let newItems = (response.item ?? []).map(BookUIModel.init(from:))
                self.items.append(contentsOf: newItems)

                // If fewer than requested, stop paging.
                if newItems.count < 30 { self.canLoadMore = false }
                self.currentPage += 1
            }
            .store(in: &cancellables)
    }

    func loadMoreIfNeeded(currentItem: BookUIModel?) {
        guard let currentItem else { return }
        let thresholdIndex = items.index(items.endIndex, offsetBy: -6, limitedBy: items.startIndex) ?? items.startIndex
        if items.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            search(reset: false)
        }
    }
}
