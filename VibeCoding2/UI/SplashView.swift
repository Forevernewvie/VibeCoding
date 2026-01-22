import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Image(systemName: "books.vertical")
                    .font(.system(size: 52, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                Text("문학 로드맵")
                    .font(.system(.largeTitle, design: .rounded).weight(.bold))
                Text("작가별 3단계 큐레이션 + 알라딘 링크")
                    .font(.callout)
                    .foregroundStyle(.secondary)

                ProgressView()
                    .padding(.top, 16)
            }
            .padding(.horizontal, 24)
        }
    }
}
