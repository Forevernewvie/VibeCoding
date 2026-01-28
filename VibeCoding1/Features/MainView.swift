import SwiftUI

struct MainView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            RoadmapRootView()
                .tag(AppState.Tab.roadmap)
                .tabItem { Label(AppConfig.roadmapTabTitle, systemImage: "point.topleft.down.curvedto.point.bottomright.up") }

            BookSearchRootView()
                .tag(AppState.Tab.search)
                .tabItem { Label(AppConfig.searchTabTitle, systemImage: "magnifyingglass") }
        }
        .environmentObject(appState)
    }
}
