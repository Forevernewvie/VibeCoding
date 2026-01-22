import SwiftUI

struct SplashView: View {
    @State private var showMain = false
    @State private var pulse = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .strokeBorder(.white.opacity(0.18), lineWidth: 1)
                        .frame(width: 120, height: 120)

                    Circle()
                        .fill(.white.opacity(pulse ? 0.18 : 0.08))
                        .frame(width: pulse ? 110 : 92, height: pulse ? 110 : 92)
                        .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true), value: pulse)

                    Text("Φ")
                        .font(.system(size: 48, weight: .semibold, design: .serif))
                        .foregroundStyle(.white)
                }

                Text("철학사 로드맵")
                    .font(.system(.title2, design: .serif).weight(.semibold))
                    .foregroundStyle(.white)

                Text("고대에서 근대까지")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.75))
            }
        }
        .onAppear {
            pulse = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.92)) {
                    showMain = true
                }
            }
        }
        .fullScreenCover(isPresented: $showMain) {
            MainView()
        }
    }
}
