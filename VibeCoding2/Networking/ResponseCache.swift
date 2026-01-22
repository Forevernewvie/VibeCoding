import Foundation
import Combine
import CryptoKit

/// Simple response cache for GET requests: in-memory (NSCache) + on-disk (Caches directory).
final class ResponseCache {
    static let shared = ResponseCache()

    private let memory = NSCache<NSString, NSData>()
    private let fm = FileManager.default
    private let folderURL: URL
    private let ttl: TimeInterval = 60 * 60 * 24 // 24h

    private init() {
        let caches = fm.urls(for: .cachesDirectory, in: .userDomainMask).first!
        folderURL = caches.appendingPathComponent("AladinResponseCache", isDirectory: true)
        try? fm.createDirectory(at: folderURL, withIntermediateDirectories: true)
        memory.countLimit = 300
    }

    func dataPublisher(for url: URL) -> AnyPublisher<Data, Error> {
        let key = url.absoluteString as NSString

        if let data = memory.object(forKey: key) {
            return Just(Data(referencing: data))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        if let diskData = loadFromDisk(for: url) {
            memory.setObject(diskData as NSData, forKey: key)
            return Just(diskData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, _ in data }
            .handleEvents(receiveOutput: { [weak self] data in
                self?.store(data: data, for: url)
            })
            .eraseToAnyPublisher()
    }

    private func store(data: Data, for url: URL) {
        let key = url.absoluteString as NSString
        memory.setObject(data as NSData, forKey: key)

        let file = fileURL(for: url)
        do {
            try data.write(to: file, options: [.atomic])
        } catch {
            // ignore disk write errors
        }
    }

    private func loadFromDisk(for url: URL) -> Data? {
        let file = fileURL(for: url)

        guard fm.fileExists(atPath: file.path) else { return nil }

        // TTL check
        if let attrs = try? fm.attributesOfItem(atPath: file.path),
           let modified = attrs[.modificationDate] as? Date {
            if Date().timeIntervalSince(modified) > ttl {
                try? fm.removeItem(at: file)
                return nil
            }
        }

        return try? Data(contentsOf: file)
    }

    private func fileURL(for url: URL) -> URL {
        let digest = SHA256.hash(data: Data(url.absoluteString.utf8))
        let name = digest.compactMap { String(format: "%02x", $0) }.joined()
        return folderURL.appendingPathComponent(name).appendingPathExtension("json")
    }
}
