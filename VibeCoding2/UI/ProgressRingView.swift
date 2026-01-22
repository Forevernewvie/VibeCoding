import SwiftUI

struct ProgressRingView: View {
    let fraction: Double
    let lineWidth: CGFloat
    let size: CGFloat
    let showsText: Bool

    init(fraction: Double, size: CGFloat = 44, lineWidth: CGFloat = 6, showsText: Bool = true) {
        self.fraction = min(max(fraction, 0), 1)
        self.size = size
        self.lineWidth = lineWidth
        self.showsText = showsText
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(.quaternary, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: fraction)
                .stroke(.tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.25), value: fraction)

            if showsText {
                Text("\(Int(fraction * 100))%")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
        .accessibilityLabel("완독률 \(Int(fraction * 100))퍼센트")
    }
}
