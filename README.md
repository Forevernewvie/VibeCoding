# 철학사 로드맵 (PhilosophyRoadmap)

> SwiftUI + Combine + MVVM 기반의 “철학자별 독서 로드맵 + 도서 검색” 앱  
> (고대/중세/근대/19세기 등 철학자 노드 선택 → 단계별 추천 로드맵 + 관련 도서 검색 결과를 함께 제공)

---

## 1) 프로젝트 요약

- **핵심 기능**
  - 철학자(예: 플라톤/아리스토텔레스/아우구스티누스/아퀴나스/데카르트/칸트 등) 선택
  - 철학자별 **3단계 로드맵(입문 → 심화 → 원전)** 템플릿 제공
  - 선택 철학자와 연관된 도서를 **Aladin OpenAPI**로 검색 (페이지네이션/최대 N개)
  - 결과 리스트에서 책 상세(Aladin 웹 페이지)로 이동

- **기술 스택**
  - UI: **SwiftUI**
  - 상태/데이터흐름: **Combine + MVVM**
  - 네트워킹: `URLSession` 기반 REST 호출
  - 파싱: `Codable`
  - 의존성: 경량(필요 최소) 원칙

---

## 2) 아키텍처 개요 (MVVM + Combine)

### 레이어 책임
- **Presentation (SwiftUI Views)**
  - 화면 구성, 사용자 입력 이벤트 전달
  - ViewModel의 `@Published` 상태를 구독해 렌더링

- **ViewModel**
  - 화면 상태(State) 보유 (`@Published`)
  - 사용자 액션 → UseCase/Service 호출 → 결과를 UI State로 변환
  - Combine로 비동기 흐름(로딩/에러/결과)을 단방향으로 정리

- **Domain (Model/UseCase)**
  - `Philosopher`, `RoadmapTemplate`, `Step` 등 앱 도메인 규칙 보관
  - “선택 철학자 → 로드맵 템플릿 생성/정리” 같은 규칙성 있는 로직 담당

- **Data (API Client)**
  - Aladin OpenAPI 호출
  - DTO ↔ Domain 변환(매핑)

---

## 3) 폴더/구조 예시

> 실제 파일명은 프로젝트마다 다를 수 있으니, README의 목적은 “역할 기준” 구조를 제시하는 것입니다.

```
PhilosophyRoadmap/
  App/
    PhilosophyRoadmapApp.swift
  Presentation/
    Views/
      HomeView.swift                 // 철학자 노드/목록/탭 진입점
      PhilosopherRoadmapView.swift   // 단계별 로드맵 + 검색결과 리스트
      BookRowView.swift
      BookDetailWebView.swift        // WKWebView 또는 SafariView
    Components/
      RoadmapStepCard.swift
      LoadingView.swift
      ErrorView.swift
  ViewModel/
    PhilosopherSelectionViewModel.swift
    BookSearchViewModel.swift
  Domain/
    Models/
      Philosopher.swift
      RoadmapTemplate.swift
      RoadmapStep.swift
      Book.swift
    Logic/
      StepClassifier.swift           // 키워드 기반 단계 분류
  Data/
    Networking/
      AladinAPIClient.swift
      AladinRequest.swift
      AladinResponseDTO.swift
```

---

## 4) 통신 방식 (Aladin OpenAPI)

### 흐름
1. View에서 “철학자 선택/검색어 입력/페이지 이동” 이벤트 발생
2. ViewModel이 `AladinAPIClient.search(...)` 호출
3. `URLSession.dataTaskPublisher` → `decode(type:)` → Domain 모델로 매핑
4. UI State 업데이트
   - `isLoading = true/false`
   - `items = [...]`
   - `errorMessage = ...`

### 예시(개념)
- HTTP: GET
- Query: `ttbkey`, `Query`, `QueryType`, `MaxResults`, `start`, `SearchTarget` 등
- Response: `item[]` 배열(도서 메타데이터)

> 실제 파라미터/필드는 Aladin OpenAPI 스펙을 따릅니다.  
> 키는 저장소에 커밋하지 않고 로컬 설정(.xcconfig, Secret.plist 등)로 주입하는 것을 권장합니다.

---

## 5) 뷰 구성

### 주요 화면
- **HomeView**
  - 시대/철학자 노드(또는 목록) 표시
  - 선택 시 `PhilosopherRoadmapView`로 이동

- **PhilosopherRoadmapView**
  - 상단: 선택 철학자 소개 + 로드맵(3단계 카드)
  - 하단: 관련 도서 검색 결과 리스트(표지/제목/저자/출판사/가격 등)
  - 탭: “로드맵 / 검색결과” 또는 한 화면 내 섹션 구분

- **BookDetailWebView**
  - 항목 탭 → Aladin 상품 페이지로 이동(WKWebView 또는 SFSafariViewController)

---

## 6) ViewModel 구성

### 공통 패턴
- `@Published var state` 혹은 `@Published` 여러 속성으로 구성
- `private var cancellables = Set<AnyCancellable>()`
- API 호출은 `sink(receiveCompletion:receiveValue:)`로 받되,
  - 에러는 사용자 친화 메시지로 변환
  - 로딩 상태는 `defer` 또는 `handleEvents`로 일관 처리

### 예시 State (개념)
- `selectedPhilosopher: Philosopher`
- `roadmapSteps: [RoadmapStep]`
- `query: String`
- `books: [Book]`
- `page: Int`, `hasNextPage: Bool`
- `isLoading: Bool`
- `alert: AlertState?`

---

## 7) (중요) 상태 꼬임/스테일 이슈 방지 팁

철학자 선택을 빠르게 연속으로 바꿀 때 “이전 요청 결과가 늦게 도착해서 현재 선택 상태를 덮어쓰는” 문제가 흔히 발생합니다.

권장 방어 패턴:
- **요청 토큰(requestId) / 선택 시점 snapshot**을 캡처하여,
  - 응답 처리 시점에 **현재 선택 철학자와 동일할 때만** 결과 반영
- 또는 Combine에서
  - `queryPublisher.combineLatest(selectedPhilosopherPublisher)`
  - `map` → `switchToLatest()`로 “최신 요청만 유지”

---

## 8) 실행/빌드

- iOS Deployment Target: 프로젝트 설정에 따름 (예: iOS 16+)
- Xcode: 최신 안정 버전 권장
- API Key/설정: 로컬 환경 주입

---

## 9) 개선 아이디어

- 검색결과 **이미지 캐시**(NSCache + AsyncImage 커스텀)
- 철학자별 “즐겨찾기/내 로드맵” 저장(로컬 DB)
- 오프라인 로드맵 열람(템플릿/메타데이터 로컬 번들)
