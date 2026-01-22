# 문학 로드맵 (LiteratureRoadmap)

> SwiftUI + CoreData + MVVM 기반의 “문학 로드맵 + 도서 탐색/저장(캐싱)” 앱  
> 읽고 싶은 작품/작가를 로드맵 형태로 정리하고, 마음에 드는 책을 **로컬에 저장(캐시)** 하여 오프라인에서도 관리할 수 있게 설계

---

## 1) 프로젝트 요약

- **핵심 기능**
  - 도서 검색/탐색(외부 API 또는 내부 데이터 소스)
  - 결과를 “즐겨찾기(저장)”로 보관
  - 즐겨찾기에 **폴더/태그/메모**를 붙여 개인화 관리
  - 즐겨찾기 상세에서 편집/삭제, 폴더별 필터링

- **기술 스택**
  - UI: **SwiftUI**
  - 상태/데이터흐름: **Combine + MVVM**
  - 로컬 저장/캐싱: **CoreData**
    - `xcdatamodeld` 없이도 동작하도록 **코드로 NSManagedObjectModel 구성**(프로젝트 정책에 따라)
  - 네트워킹: `URLSession` 기반(사용 시)

---

## 2) 아키텍처 개요 (MVVM + Persistence)

### 레이어 책임
- **Presentation (SwiftUI Views)**
  - 리스트/상세/편집 폼 UI
  - ViewModel의 상태를 관찰해 렌더링

- **ViewModel / Store**
  - 화면 상태 + 사용자 이벤트 처리
  - CoreData CRUD를 단일 진입점으로 감싸서 View의 관심사를 최소화
  - 검색 결과(원격)와 저장 목록(로컬)을 “하나의 UX 흐름”으로 연결

- **Persistence (CoreData)**
  - `PersistenceController`가 NSPersistentContainer 생성/관리
  - 즐겨찾기 엔티티(`FavoriteBook`)를 중심으로 폴더/태그/메모 등 관리

---

## 3) 폴더/구조 예시

```
LiteratureRoadmap/
  App/
    LiteratureRoadmapApp.swift
  Presentation/
    Views/
      SearchView.swift               // 검색/탐색
      SearchResultListView.swift
      FavoritesView.swift            // 저장(캐시)된 목록
      FavoriteDetailView.swift       // 폴더/태그/메모 편집 Form
    Components/
      BookRowView.swift
      TagChipsView.swift
      EmptyStateView.swift
  ViewModel/
    SearchViewModel.swift            // (원격/로컬) 검색 상태
    FavoritesStore.swift             // 즐겨찾기 CRUD + 폴더 목록
  Domain/
    Models/
      Book.swift                     // 원격/로컬 공통 모델(가능하면)
  Data/
    Networking/
      BookAPIClient.swift            // 필요 시
  Persistence/
    PersistenceController.swift      // NSPersistentContainer/Context 제공
    Model/
      CoreDataModelBuilder.swift     // NSManagedObjectModel을 코드로 구성(선택)
    Entities/
      FavoriteBook+CoreDataClass.swift
      FavoriteBook+CoreDataProperties.swift
```

> `FavoritesStore` 같은 Store 객체를 “ViewModel 성격”으로 둬도 됩니다.  
> 중요한 건 **View는 CoreData 세부를 몰라도 되게** 단일 진입점을 제공하는 것입니다.

---

## 4) 통신 방식 (원격 검색이 있는 경우)

### 흐름
1. `SearchView`에서 검색어 입력
2. `SearchViewModel`이 API Client 호출
3. 결과를 `books: [Book]`로 노출
4. 사용자가 “저장”을 누르면 `FavoritesStore.save(book:)` 실행
5. 저장 목록 화면에서 즉시 반영(ObservedObject/FetchRequest/Publisher)

---

## 5) 뷰 구성

### 주요 화면
- **SearchView**
  - 검색창 + 결과 리스트
  - 각 Row에 “저장(즐겨찾기)” 액션 제공

- **FavoritesView**
  - 로컬에 저장된 항목 리스트
  - 폴더/태그 필터링(선택 사항)
  - 정렬(최근 저장/제목/작가 등)

- **FavoriteDetailView**
  - Form 기반 편집 UI
  - 폴더 Picker, 태그 TextField, 메모 TextEditor
  - 저장/닫기 툴바 액션

---

## 6) ViewModel 구성

### SearchViewModel (개념)
- 입력
  - `query: String`
  - `page: Int`
- 출력
  - `books: [Book]`
  - `isLoading: Bool`
  - `errorMessage: String?`
- 로직
  - 디바운스(입력 과도 요청 방지)
  - `switchToLatest`로 최신 검색만 반영
  - 페이지네이션 시 기존 결과에 append

### FavoritesStore (개념)
- 출력
  - `favorites: [FavoriteBookViewData]` 또는 FetchRequest 바인딩
  - `folders: [String]`
- 기능
  - `save(book:)`
  - `delete(favorite:)`
  - `update(favoriteId:, folder:, tags:, memo:)`
  - 폴더 목록 자동 생성/정규화(빈 값 처리)

---

## 7) 캐싱/저장 전략 (문학 로드맵 핵심)

문학 로드맵의 “캐싱”은 크게 3층으로 보면 좋습니다.

### 7.1 1차 캐시: CoreData (영구 저장)
- **대상**
  - 사용자가 “저장”한 도서(즐겨찾기)
  - 사용자 커스텀 필드: `folderName`, `tags`, `memo`
  - 식별자: ISBN 또는 (title+author) 조합 등 “중복 방지 키”
- **장점**
  - 앱 종료/재실행 후에도 유지
  - 오프라인에서도 목록/상세/편집 가능

- **중복 저장 방지**
  - 저장 시 먼저 동일 ISBN 존재 여부 조회
  - 있으면 update, 없으면 insert

- **성능**
  - 목록 화면은 FetchRequest/NSFetchedResultsController 개념을 활용하거나,
    Store에서 `NSFetchRequest`를 수행해 결과를 `@Published`로 노출

### 7.2 2차 캐시: 이미지 캐시(선택)
- 표지 이미지 URL이 있다면
  - `NSCache<NSURL, UIImage>` 기반 캐시를 두고,
  - SwiftUI `AsyncImage`를 커스터마이징해 동일 URL 재요청을 줄입니다.

### 7.3 3차 캐시: URLCache(선택)
- 원격 검색 API가 있고 반복 호출이 잦다면
  - `URLSessionConfiguration.default.urlCache` 설정으로
  - 동일 요청/응답을 단기간 캐시할 수 있습니다.

---

## 8) CoreData 모델(코드 구성) 가이드

프로젝트 정책상 `.xcdatamodeld` 없이 구성한다면:

- `NSManagedObjectModel()` 생성
- `NSEntityDescription` / `NSAttributeDescription`로 엔티티/속성 정의
- `NSPersistentContainer(name:managedObjectModel:)`로 컨테이너 생성
- `loadPersistentStores` 완료 후 `viewContext.mergePolicy` 등 설정

**주의 포인트**
- AttributeType enum 케이스는 `NSInteger64AttributeType`처럼  
  실제 Swift 케이스명이 SDK 변화에 따라 달라질 수 있어 컴파일 에러가 날 수 있습니다.
- 마이그레이션이 필요해질 수 있으므로, 버전업 시에는
  - 필드 추가/변경 전략(경량 마이그레이션 vs 수동)을 미리 정해두는 것이 좋습니다.

---

## 9) 실행/빌드

- iOS Deployment Target: 예) iOS 16+
- CoreData 저장소:
  - 디바이스: App Sandbox 내 sqlite
  - 테스트: inMemory 옵션(`/dev/null`) 지원 권장

---

## 10) 개선 아이디어

- 폴더/태그를 별도 엔티티로 정규화 (검색/집계 성능 향상)
- 즐겨찾기 export/import(JSON)로 백업
- 검색결과와 즐겨찾기 동기화(저장 여부 표시)
