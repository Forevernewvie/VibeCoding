import SwiftUI

struct BookSearchRootView: View {
    @StateObject private var vm = BookSearchViewModel()
    @EnvironmentObject private var appState: AppState
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                searchBar

                if let msg = vm.errorMessage {
                    Text("오류: \(msg)")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                List {
                    ForEach(vm.results) { book in
                        BookRow(book: book)
                            .onAppear { vm.loadMoreIfNeeded(current: book) }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if let s = book.link, let url = URL(string: s) {
                                    openURL(url)
                                }
                            }
                    }

                    if vm.isLoading {
                        HStack { Spacer(); ProgressView(); Spacer() }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("도서 검색")
            .onChange(of: appState.pendingSearchQuery) { newValue in
                guard let q = newValue else { return }
                vm.query = q
                vm.search(reset: true)
                // consume
                appState.pendingSearchQuery = nil
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            TextField("책/저자/키워드 검색", text: $vm.query)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit { vm.search(reset: true) }

            Button {
                vm.search(reset: true)
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(10)
                    .background(Color.indigo.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
    }
}

struct BookRow: View {
    let book: BookItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: book.cover ?? "")) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.12))
                        .frame(width: 56, height: 78)
                case .success(let img):
                    img.resizable().scaledToFill()
                        .frame(width: 56, height: 78)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                case .failure:
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.12))
                        .overlay(Image(systemName: "book").foregroundStyle(.secondary))
                        .frame(width: 56, height: 78)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(book.title ?? "제목 없음")
                    .font(.system(.headline, design: .rounded))
                    .lineLimit(2)
                
                Text([book.author, book.publisher].compactMap { $0 }.joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                if let isbn13 = book.isbn13, !isbn13.isEmpty {
                    Text("ISBN13 \(isbn13)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                } else if let isbn = book.isbn, !isbn.isEmpty {
                    Text("ISBN \(isbn)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                HStack(spacing: 10) {
                    if let standard = book.priceStandard {
                        Text("정가 \(standard)원")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if let sales = book.priceSales {
                        Text("할인가 \(sales)원")
                            .font(.caption)
                            .foregroundStyle(.indigo)
                    }
                }

                if let desc = book.description, !desc.isEmpty {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
                .padding(.top, 6)
        }
        .padding(.vertical, 10)
    }
}
