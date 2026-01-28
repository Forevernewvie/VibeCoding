import Foundation

enum AppConfig {
    // ⚠️ 보안: 배포 시 앱에 TTBKey를 넣지 마세요.
    // 이 샘플은 개발/학습용이며, 아래 프록시(Proxy 폴더)로 이동하는 구성을 포함합니다.
    static let ttbKeyForDev = "ttbcjb110551824001" // 개발용 (요청하신 키)

    // 도메인(알라딘 TTB에 등록하신 것)
    static let registeredDomain = "http://jerrychoi.com"

    // ✅ 키 노출 방지: 프록시 사용 여부
    static let useProxy: Bool = false

    // 프록시 주소(본인 서버/워커 배포 후 변경)
    static let proxyBaseURL = URL(string: "https://YOUR_PROXY_DOMAIN")!

    // 알라딘 원본 API
    static let aladinBaseURL = URL(string: "http://www.aladin.co.kr/ttb/api")!

    static var baseURL: URL { useProxy ? proxyBaseURL : aladinBaseURL }

    // API 기본값
    static let apiVersion = "20131101"

    // 알라딘 JSON 출력은 output=js가 호환이 좋은 편
    static let output = "js"

    // MainView
    static let roadmapTabTitle = "로드맵"
    static let searchTabTitle = "검색"

    // SplashView
    static let splashTitle = "철학사 로드맵"
    static let splashSubtitle = "고대에서 근대까지"

    // BookSearchViews
    static let searchErrorPrefix = "오류: "
    static let bookSearchTitle = "도서 검색"
    static let bookSearchPlaceholder = "책/저자/키워드 검색"
    static let emptyCoverURL = ""
    static let noTitle = "제목 없음"
    static let authorPublisherSeparator = " · "
    static let isbn13Prefix = "ISBN13 "
    static let isbnPrefix = "ISBN "
    static let priceStandardPrefix = "정가 "
    static let priceSalesPrefix = "할인가 "
    static let priceSuffix = "원"

    // BookSearchViewModel
    static let defaultQuery = ""
    static let aladinQueryTypeKeyword = "Keyword"
    static let aladinMaxResults = 30

    // RoadmapViews
    static let roadmapNavigationTitle = "철학사 로드맵"
    static let roadmapHeaderTitle = "고대 → 중세 -> 근대 -> 19세기"
    static let roadmapHeaderSubtitle = "추천은 ‘정답 로드맵(필독)’을 먼저 깔고, 알라딘은 표지/가격/링크를 보강합니다."
    static let curatedRecommendation = "필독 추천"
    static let extendedReading = "확장 읽기"
    static let philosopherTitle = "철학자"
    static let eraAncient = "고대"
    static let eraMedieval = "중세"
    static let eraModern = "근대"
    static let eraNineteenth = "19세기"
    static let eraAncientPhilosophy = "고대 철학"
    static let eraMedievalPhilosophy = "중세 철학"
    static let eraModernPhilosophy = "근대 철학"
    static let eraNineteenthPhilosophy = "19세기 철학"
    static let roadmapSuffix = " 로드맵"
    static let errorText = "오류"
    static let searchMoreText = "검색에서 더보기"
    static let expandText = "펼쳐보기"
    static let curatedCountPrefix = "필독 "
    static let extendedCountPrefix = " · 확장 "

    // Plato
    static let platoDialogue = "대화편"
    static let platoRepublic = "국가"
    static let platoTimaeus = "티마이오스"

    // Aristotle
    static let aristotleEthics = "윤리"
    static let aristotleLogic = "논리"
    static let aristotleMetaphysics = "형이상학"

    // Augustine
    static let augustineConfessions = "고백록"
    static let augustineCityOfGod = "신국론"
    static let augustineTrinity = "삼위일체"

    // Anselm
    static let anselmProslogion = "프로슬로기온"
    static let anselmOntologicalArgument = "존재논증"
    static let anselmCurDeusHomo = "Cur Deus Homo"

    // Aquinas
    static let aquinasIntroduction = "입문"
    static let aquinasSummaTheologica = "신학대전"
    static let aquinasCommentary = "주석"

    // Boethius
    static let boethiusConsolation = "철학의 위안"
    static let boethiusTheology = "신학"
    static let boethiusAnthology = "선집"

    // Avicenna
    static let avicennaIntroduction = "입문"
    static let avicennaMetaphysics = "형이상학"
    static let avicennaBookOfHealing = "치유의 서"

    // Averroes
    static let averroesIntroduction = "입문"
    static let averroesCommentary = "주석"
    static let averroesAristotle = "아리스토텔레스"

    // Duns Scotus
    static let dunsScotusIntroduction = "입문"
    static let dunsScotusMetaphysics = "형이상학"
    static let dunsScotusLectures = "강해"

    // Ockham
    static let ockhamIntroduction = "입문"
    static let ockhamLogic = "논리학"
    static let ockhamNominalism = "명목론"

    // Descartes
    static let descartesDiscourse = "방법서설"
    static let descartesMeditations = "성찰"
    static let descartesPassions = "정념론"

    // Spinoza
    static let spinozaIntroduction = "입문"
    static let spinozaEthics = "윤리학"
    static let spinozaTheologicoPolitical = "신학정치론"

    // Locke
    static let lockeIntroduction = "입문"
    static let lockeHumanUnderstanding = "인간오성"
    static let lockeGovernment = "정부론"

    // Leibniz
    static let leibnizIntroduction = "입문"
    static let leibnizMonadology = "단자론"
    static let leibnizTheodicy = "신정론"

    // Hume
    static let humeIntroduction = "입문"
    static let humeHumanNature = "인성론"
    static let humeEnquiry = "탐구"

    // Rousseau
    static let rousseauIntroduction = "입문"
    static let rousseauSocialContract = "사회계약론"
    static let rousseauEmile = "에밀"

    // Kant
    static let kantIntroduction = "입문"
    static let kantPureReason = "순수이성비판"
    static let kantPracticalReason = "실천이성비판"

    // Marx
    static let marxIntroduction = "입문"
    static let marxCommunistManifesto = "공산당 선언"
    static let marxCapital = "자본"

    // Hegel
    static let hegelIntroduction = "입문"
    static let hegelPhenomenology = "정신현상학"
    static let hegelPhilosophyOfRight = "법철학"

    // Nietzsche
    static let nietzscheIntroduction = "입문"
    static let nietzscheZarathustra = "차라투스트라"
    static let nietzscheGenealogyOfMorality = "도덕의 계보"

    // Kierkegaard
    static let kierkegaardIntroduction = "입문"
    static let kierkegaardSicknessUntoDeath = "죽음에 이르는 병"
    static let kierkegaardConceptOfAnxiety = "불안의 개념"

    // RoadmapViewModel
    static let bestsellerPagesToScan = 6
    static let aladinPageSize = 50
    static let aladinQueryTypeTitle = "Title"
    static let aladinQueryTypeAuthor = "Author"
    static let emptyString = ""
    static let scoreTitleMatch = 5
    static let scoreAuthorMatch = 3
    static let scoreIsbnCoverMatch = 1
    static let bestMatchScoreThreshold = 5
    static let normalizeSpace = " "
    static let normalizeDot = "·"
    static let normalizeColon = ":"
    static let normalizeDashLong = "—"
    static let normalizeDashShort = "-"
    static let normalizeParenthesisOpen = "("
    static let normalizeParenthesisClose = ")"
    static let extendedRecommendationLimit = 24
    static let limitPerStep = 10

    // AladinAPI
    static let aladinPathItemSearch = "ItemSearch.aspx"
    static let aladinPathItemList = "ItemList.aspx"
    static let aladinProxyPrefix = "aladin"
    static let aladinQueryItemOutput = "output"
    static let aladinQueryItemVersion = "Version"
    static let aladinQueryItemTtbKey = "ttbkey"
    static let aladinQueryItemQuery = "Query"
    static let aladinQueryItemQueryType = "QueryType"
    static let aladinQueryItemSearchTarget = "SearchTarget"
    static let aladinSearchTargetBook = "Book"
    static let aladinQueryItemStart = "start"
    static let aladinQueryItemMaxResults = "MaxResults"
    static let aladinQueryTypeBestseller = "Bestseller"

    // CuratedRoadmap
    static let roleIntroduction = "입문"
    static let roleCore = "핵심"
    static let roleAdvanced = "심화"

    // RoadmapData
    static let eraAncientPhilosophyString = "고대 철학"
    static let eraMedievalPhilosophyString = "중세 철학"
    static let eraModernPhilosophyString = "근대 철학"
    static let eraNineteenthPhilosophyString = "19세기 철학"
    static let step1Title = "STEP 1"
    static let step2Title = "STEP 2"
    static let step3Title = "STEP 3"
    static let step1SubtitleIntro = "짧은 대화편으로 진입"
    static let step2SubtitleCore = "핵심: 국가·향연"
    static let step3SubtitleAdvanced = "심화: 티마이오스·법률"
    static let step1SubtitleEthicsPolitics = "윤리·정치로 감각 잡기"
    static let step2SubtitleLogic = "논리(오르가논)로 문법 만들기"
    static let step3SubtitleMetaphysics = "형이상학·자연학으로 본령"
    static let step1SubtitleInnerReflection = "내면 성찰로 진입"
    static let step2SubtitleHistoryPoliticsTheology = "역사·정치·신학의 틀"
    static let step3SubtitleMetaphysicsTheologyAdvanced = "형이상학/신학 심화"
    static let step1SubtitleShortArguments = "짧은 논증 텍스트로 진입"
    static let step2SubtitleOntologicalArgumentCore = "신 존재 논증 핵심"
    static let step3SubtitleAtonementScholasticAdvanced = "속죄·스콜라 논쟁 심화"
    static let step1SubtitleIntroductionMap = "입문서로 지도 만들기"
    static let step2SubtitleSummaTheologicaCore = "신학대전/핵심 논점"
    static let step3SubtitleCommentaryMetaphysicsAdvanced = "주석·형이상학 심화"
    static let step1SubtitleKeyConceptsIntro = "핵심 텍스트/개론으로 진입"
    static let step2SubtitleMainPoints = "주요 논점(존재·인식·신)"
    static let step3SubtitleScholasticDebateAdvanced = "스콜라 논쟁/주석 심화"
    static let step1SubtitleMethodSelfIntro = "방법·자아로 진입"
    static let step2SubtitleEpistemologyMetaphysicsCore = "인식론·형이상학 핵심"
    static let step3SubtitlePassionsScientificWorldview = "정념/과학적 세계관까지 확장"
    static let step1SubtitleMonismMap = "사상 지도(일원론) 만들기"
    static let step2SubtitleEthicsCore = "윤리학 핵심 정리"
    static let step3SubtitlePoliticsTheologyAdvanced = "정치·신학 논쟁까지 확장"
    static let step1SubtitleIntroCoreTexts = "입문/핵심 텍스트로 진입"
    static let step2SubtitleReadOneMajorWork = "대표 저작 1권 완독"
    static let step3SubtitleAdvancedTextsCommentary = "심화 텍스트/해설 병행"
    static let step1SubtitleSocialHistoryIntro = "문제의식(사회·역사) 진입"
    static let step2SubtitleCoreEssaysManifesto = "핵심 논문/선언"
    static let step3SubtitleCapitalPoliticalEconomyAdvanced = "자본/정치경제학 심화"
    static let step1SubtitleIntroductoryMap = "입문서로 지도 만들기"
    static let step2SubtitleReadOneRepresentativeWork = "대표 저작 1권 완독"
    static let step3SubtitleLecturesCommentaryAdvanced = "강의/해설 병행 심화"

}
