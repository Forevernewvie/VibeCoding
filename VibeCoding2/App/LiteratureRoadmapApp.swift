import SwiftUI

@main
struct LiteratureRoadmapApp: App {
    @StateObject private var favorites = FavoritesStore()
    @StateObject private var progress = ProgressStore()
    @StateObject private var roadmapVM = RoadmapViewModel()
    @StateObject private var searchVM = SearchViewModel()

    @State private var showingSplash: Bool = true

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(favorites)
                .environmentObject(progress)
                .environmentObject(roadmapVM)
                .environmentObject(searchVM)
                .overlay {
                    if showingSplash {
                        SplashView()
                            .transition(.opacity)
                    }
                }
                .task {
                    // Simple in-app splash (LaunchScreen storyboard 없이도 작동)
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    withAnimation(.easeOut(duration: 0.5)) {
                        showingSplash = false
                    }
                }
        }
    }
}
