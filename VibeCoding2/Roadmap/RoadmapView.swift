import SwiftUI

struct RoadmapView: View {
    @EnvironmentObject private var vm: RoadmapViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.authors) { author in
                    NavigationLink {
                        RoadmapDetailView(author: author)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(author.name)
                                .font(.headline)
                            Text("\(author.nationality) · \(author.era)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(author.tagline)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("문학 로드맵")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Section("필터") {
                            Picker("국가", selection: $vm.selectedNationality) {
                                Text("전체").tag(String?.none)
                                ForEach(vm.nationalities, id: \.self) { v in
                                    Text(v).tag(String?.some(v))
                                }
                            }

                            Picker("시대", selection: $vm.selectedEra) {
                                Text("전체").tag(String?.none)
                                ForEach(vm.eras, id: \.self) { v in
                                    Text(v).tag(String?.some(v))
                                }
                            }

                            Picker("난이도", selection: $vm.selectedDifficulty) {
                                Text("전체").tag(RoadmapDifficulty?.none)
                                ForEach(RoadmapDifficulty.allCases) { d in
                                    Text(d.rawValue).tag(RoadmapDifficulty?.some(d))
                                }
                            }
                        }

                        Section("정렬") {
                            Picker("정렬 기준", selection: $vm.sortOption) {
                                ForEach(RoadmapViewModel.SortOption.allCases) { s in
                                    Text(s.rawValue).tag(s)
                                }
                            }
                            Toggle("오름차순", isOn: $vm.sortAscending)
                        }

                        Divider()
                        Button("필터/정렬 초기화", role: .destructive) {
                            vm.resetFilters()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    .accessibilityLabel("필터 및 정렬")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        RoadmapAboutView()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
    }
}

private struct RoadmapAboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("로드맵은 ‘정답’이 아니라 ‘루트’입니다.")
                    .font(.title2.bold())
                Text("알라딘 OpenAPI는 로드맵 자체를 제공하지 않기 때문에, 이 앱은 작가별 3단계(입문/핵심/심화) 추천을 하드코딩 seed로 가지고 있고, 표지/링크/요약 같은 상품 정보는 API로 보강합니다.")
                    .foregroundStyle(.secondary)
                Text("TIP")
                    .font(.headline)
                    .padding(.top, 8)
                Text("• 한 단계에서 2권만 골라도 OK\n• 어려우면 Step 1로 되돌아가도 OK\n• ‘완독’보다 ‘지속’이 이깁니다")
            }
            .padding()
        }
        .navigationTitle("설명")
        .navigationBarTitleDisplayMode(.inline)
    }
}
