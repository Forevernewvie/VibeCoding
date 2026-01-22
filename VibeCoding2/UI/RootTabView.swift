import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            RoadmapView()
                .tabItem { Label("로드맵", systemImage: "map") }

            SearchView()
                .tabItem { Label("검색", systemImage: "magnifyingglass") }

            FavoritesView()
                .tabItem { Label("즐겨찾기", systemImage: "heart") }
        }
    }
}
