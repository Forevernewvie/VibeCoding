import SwiftUI

struct MainView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            RoadmapRootView()
                .tag(AppState.Tab.roadmap)
                .tabItem { Label("로드맵", systemImage: "point.topleft.down.curvedto.point.bottomright.up") }

            BookSearchRootView()
                .tag(AppState.Tab.search)
                .tabItem { Label("검색", systemImage: "magnifyingglass") }
        }
        .environmentObject(appState)
    }
}
