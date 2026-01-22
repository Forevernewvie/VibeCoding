import SwiftUI
import UIKit

/// Async image loader with NSCache-based memory caching.
struct CachedAsyncImageView<Placeholder: View>: View {
    let url: URL?
    let placeholder: Placeholder

    @State private var image: Image? = nil
    @State private var isLoading: Bool = false

    init(url: URL?, @ViewBuilder placeholder: () -> Placeholder) {
        self.url = url
        self.placeholder = placeholder()
    }

    var body: some View {
        ZStack {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .task(id: url) {
            await load()
        }
    }

    private func load() async {
        guard let url else { return }
        if let cached = ImageCache.shared.image(for: url) {
            image = Image(uiImage: cached)
            return
        }
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.insert(uiImage, for: url)
                image = Image(uiImage: uiImage)
            }
        } catch {
            // ignore
        }
    }
}
