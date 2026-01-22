import SwiftUI

struct BookRowView: View {
    let book: BookUIModel
    let subtitle: String?
    let onTap: () -> Void
    let onToggleFavorite: () -> Void
    let isFavorited: Bool
    let onToggleCompleted: (() -> Void)?
    let isCompleted: Bool

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                CachedAsyncImageView(url: book.coverURL) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.quaternary)
                        .frame(width: 60, height: 86)
                        .overlay(ProgressView())
                }
                .frame(width: 60, height: 86)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    Text(book.author)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                    if let subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
                Spacer(minLength: 8)

                if let onToggleCompleted {
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            onToggleCompleted()
                        }
                        Haptics.success()
                    }) {
                        Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(isCompleted ? .green : .secondary)
                            .padding(6)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isCompleted ? "완독 해제" : "완독 체크")
                }

                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                        onToggleFavorite()
                    }
                    Haptics.lightImpact()
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundStyle(isFavorited ? .red : .secondary)
                        .padding(6)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isFavorited ? "즐겨찾기 해제" : "즐겨찾기 추가")
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 6)
    }
}
