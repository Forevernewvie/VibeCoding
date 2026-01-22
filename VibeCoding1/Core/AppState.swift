import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    enum Tab: Hashable {
        case roadmap
        case search
    }

    @Published var selectedTab: Tab = .roadmap
    @Published var pendingSearchQuery: String? = nil

    func openSearch(with query: String) {
        pendingSearchQuery = query
        selectedTab = .search
    }
}
