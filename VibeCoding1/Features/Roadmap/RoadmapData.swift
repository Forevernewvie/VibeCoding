import Foundation

enum Philosopher: String, CaseIterable, Identifiable {
    // Ancient
    case plato = "플라톤"
    case aristotle = "아리스토텔레스"

    // Medieval (expanded)
    case augustine = "아우구스티누스"
    case anselm = "안셀무스"
    case aquinas = "토마스 아퀴나스"
    case avicenna = "이븐 시나(아비센나)"
    case averroes = "이븐 루시드(아베로에스)"
    case boethius = "보에티우스"
    case dunsScotus = "둔스 스코투스"
    case ockham = "오컴"

    // Early modern / Modern
    case descartes = "데카르트"
    case spinoza = "스피노자"
    case locke = "로크"
    case leibniz = "라이프니츠"
    case hume = "흄"
    case rousseau = "루소"
    case kant = "칸트"

    // 19th century
    case marx = "마르크스"
    case hegel = "헤겔"
    case nietzsche = "니체"
    case kierkegaard = "키르케고르"

    var id: String { rawValue }

    var era: String {
        switch self {
        case .plato, .aristotle:
            return AppConfig.eraAncientPhilosophyString
        case .augustine, .anselm, .aquinas, .avicenna, .averroes, .boethius, .dunsScotus, .ockham:
            return AppConfig.eraMedievalPhilosophyString
        case .descartes, .spinoza, .locke, .leibniz, .hume, .rousseau, .kant:
            // 흄/루소/칸트는 18세기지만 보통 근대 계열로 묶어 학습 로드맵에 넣기 좋음
            return AppConfig.eraModernPhilosophyString
        case .marx, .hegel, .nietzsche, .kierkegaard:
            return AppConfig.eraNineteenthPhilosophyString
        }
    }

    /// 알라딘 저자/키워드 검색에 사용할 기본 쿼리
    var authorQuery: String { rawValue }

    /// 확장 읽기(베스트셀러 필터)에서 쓰는 토큰들
    var filterTokens: [String] {
        switch self {
        case .plato:
            return ["플라톤", "plato", "소크라테스", "socrates"]
        case .aristotle:
            return ["아리스토텔레스", "aristotle", "오르가논", "니코마코스"]
        case .augustine:
            return ["아우구스티누스", "augustine"]
        case .anselm:
            return ["안셀무스", "anselm"]
        case .aquinas:
            return ["아퀴나스", "토마스", "thomas aquinas", "aquinas"]
        case .avicenna:
            return ["이븐 시나", "아비센나", "avicenna", "ibn sina"]
        case .averroes:
            return ["이븐 루시드", "아베로에스", "averroes", "ibn rushd"]
        case .boethius:
            return ["보에티우스", "boethius"]
        case .dunsScotus:
            return ["둔스 스코투스", "scotus", "duns scotus"]
        case .ockham:
            return ["오컴", "ockham", "오컴의 면도날"]
        case .descartes:
            return ["데카르트", "descartes", "cartes"]
        case .spinoza:
            return ["스피노자", "spinoza"]
        case .locke:
            return ["로크", "locke"]
        case .leibniz:
            return ["라이프니츠", "leibniz"]
        case .hume:
            return ["흄", "hume"]
        case .rousseau:
            return ["루소", "rousseau"]
        case .kant:
            return ["칸트", "kant"]
        case .marx:
            return ["마르크스", "marx"]
        case .hegel:
            return ["헤겔", "hegel"]
        case .nietzsche:
            return ["니체", "nietzsche"]
        case .kierkegaard:
            return ["키르케고르", "kierkegaard"]
        }
    }

    var blurb: String {
        switch self {
        // Ancient
        case .plato: return "이데아·국가·대화편"
        case .aristotle: return "논리·윤리·형이상학"

        // Medieval
        case .augustine: return "내면·신학·자유의지"
        case .anselm: return "신 존재 논증·스콜라 초기"
        case .aquinas: return "스콜라 정점·신학대전"
        case .avicenna: return "이슬람 철학·존재론"
        case .averroes: return "아리스토텔레스 주석·이성"
        case .boethius: return "고대-중세 교량"
        case .dunsScotus: return "형이상학·개별성"
        case .ockham: return "명목론·방법의 전환"

        // Modern
        case .descartes: return "방법·자아·근대의 시작"
        case .spinoza: return "일원론·윤리학"
        case .locke: return "경험론·정치철학"
        case .leibniz: return "단자론·합리론"
        case .hume: return "회의론·경험론 정점"
        case .rousseau: return "사회계약·근대 정치"
        case .kant: return "비판철학·인식론"

        // 19th
        case .marx: return "역사유물론·자본"
        case .hegel: return "변증법·정신"
        case .nietzsche: return "가치 전도·계보"
        case .kierkegaard: return "실존·주체성"
        }
    }
}


struct RoadmapStep: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
}

enum RoadmapTemplate {
    static func steps(for p: Philosopher) -> [RoadmapStep] {
        switch p {
        // Ancient
        case .plato:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleIntro),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleCore),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitleAdvanced)
            ]
        case .aristotle:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleEthicsPolitics),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleLogic),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitleMetaphysics)
            ]

        // Medieval (expanded)
        case .augustine:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleInnerReflection),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleHistoryPoliticsTheology),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitleMetaphysicsTheologyAdvanced)
            ]
        case .anselm:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleShortArguments),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleOntologicalArgumentCore),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitleAtonementScholasticAdvanced)
            ]
        case .aquinas:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleIntroductionMap),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleSummaTheologicaCore),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitleCommentaryMetaphysicsAdvanced)
            ]
        case .boethius, .avicenna, .averroes, .dunsScotus, .ockham:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleKeyConceptsIntro),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleMainPoints),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitleScholasticDebateAdvanced)
            ]

        // Modern
        case .descartes:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleMethodSelfIntro),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleEpistemologyMetaphysicsCore),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitlePassionsScientificWorldview)
            ]
        case .spinoza:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleMonismMap),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleEthicsCore),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitlePoliticsTheologyAdvanced)
            ]
        case .locke, .leibniz, .hume, .rousseau, .kant:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleIntroCoreTexts),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleReadOneMajorWork),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitleAdvancedTextsCommentary)
            ]

        // 19th
        case .marx:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleSocialHistoryIntro),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleCoreEssaysManifesto),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitleCapitalPoliticalEconomyAdvanced)
            ]
        case .hegel, .nietzsche, .kierkegaard:
            return [
                .init(title: AppConfig.step1Title, subtitle: AppConfig.step1SubtitleIntroductoryMap),
                .init(title: AppConfig.step2Title, subtitle: AppConfig.step2SubtitleReadOneRepresentativeWork),
                .init(title: AppConfig.step3Title, subtitle: AppConfig.step3SubtitleLecturesCommentaryAdvanced)
            ]
        }
    }
}




/// 단계별 키워드 기반 자동 분류 (추가 업그레이드)
/// - 로드맵은 3단계 고정
/// - 각 단계에 "주제 키워드"를 두고, 제목/설명에 매칭되는 점수가 가장 높은 단계로 분배
enum StepClassifier {
    struct StepRule {
        let stepIndex: Int   // 0,1,2
        let keywords: [String]
    }

    static func rules(for p: Philosopher) -> [StepRule] {
        switch p {
        case .plato:
            return [
                .init(stepIndex: 0, keywords: ["대화편", "입문", "소크라테스", "변론", "크리톤", "에우튀프론", "메논", "plato"]),
                .init(stepIndex: 1, keywords: ["국가", "향연", "파이돈", "파이드로스", "정의", "이데아", "republic", "symposium"]),
                .init(stepIndex: 2, keywords: ["티마이오스", "법률", "파르메니데스", "소피스트", "정치가", "우주", "timaeus", "laws"])
            ]
        case .aristotle:
            return [
                .init(stepIndex: 0, keywords: ["윤리", "니코마코스", "정치학", "시학", "수사학", "행복", "virtue", "ethics", "poetics"]),
                .init(stepIndex: 1, keywords: ["논리", "범주론", "명제", "해석", "오르가논", "분석론", "topics", "logic", "categories"]),
                .init(stepIndex: 2, keywords: ["형이상학", "자연학", "영혼", "존재", "원인", "metaphysics", "physics", "de anima"])
            ]

        // Medieval
        case .augustine:
            return [
                .init(stepIndex: 0, keywords: ["고백록", "회심", "내면", "confessions"]),
                .init(stepIndex: 1, keywords: ["신국론", "역사", "도시", "국가", "city of god"]),
                .init(stepIndex: 2, keywords: ["삼위일체", "자유의지", "은총", "원죄", "trinity", "free will"])
            ]
        case .anselm:
            return [
                .init(stepIndex: 0, keywords: ["프로슬로기온", "모놀로기온", "proslogion", "monologion"]),
                .init(stepIndex: 1, keywords: ["존재", "신 존재", "논증", "ontological", "proof", "존재논증"]),
                .init(stepIndex: 2, keywords: ["속죄", "만족", "cur deus homo", "스콜라"])
            ]
        case .aquinas:
            return [
                .init(stepIndex: 0, keywords: ["입문", "요약", "가이드", "개론", "introduction"]),
                .init(stepIndex: 1, keywords: ["신학대전", "summa", "제1부", "제2부", "제3부"]),
                .init(stepIndex: 2, keywords: ["주석", "아리스토텔레스", "형이상학", "commentary"])
            ]
        case .boethius, .avicenna, .averroes, .dunsScotus, .ockham:
            return [
                .init(stepIndex: 0, keywords: ["입문", "개론", "가이드", "선집", "introduction"]),
                .init(stepIndex: 1, keywords: ["존재", "인식", "이성", "신", "논증", "metaphysics"]),
                .init(stepIndex: 2, keywords: ["주석", "논쟁", "스콜라", "commentary", "해설"])
            ]

        // Modern
        case .descartes:
            return [
                .init(stepIndex: 0, keywords: ["방법서설", "방법", "discourse on method", "입문", "guide"]),
                .init(stepIndex: 1, keywords: ["성찰", "제1철학", "meditations", "본유관념", "인식"]),
                .init(stepIndex: 2, keywords: ["정념론", "passions", "철학의 원리", "principles", "자연"])
            ]
        case .spinoza:
            return [
                .init(stepIndex: 0, keywords: ["입문", "가이드", "지도", "introduction"]),
                .init(stepIndex: 1, keywords: ["윤리학", "ethics", "기하학적", "실체", "일원론"]),
                .init(stepIndex: 2, keywords: ["정치", "신학정치", "theological-political", "서간"])
            ]
        case .locke:
            return [
                .init(stepIndex: 0, keywords: ["입문", "개론", "guide"]),
                .init(stepIndex: 1, keywords: ["인간오성", "human understanding", "경험론"]),
                .init(stepIndex: 2, keywords: ["정부론", "letters", "심화", "해설"])
            ]
        case .leibniz:
            return [
                .init(stepIndex: 0, keywords: ["입문", "개론", "guide"]),
                .init(stepIndex: 1, keywords: ["단자론", "monadology", "형이상학"]),
                .init(stepIndex: 2, keywords: ["신정론", "theodicy", "서간", "해설"])
            ]
        case .hume:
            return [
                .init(stepIndex: 0, keywords: ["입문", "개론", "guide"]),
                .init(stepIndex: 1, keywords: ["인성론", "treatise", "인간본성", "human nature"]),
                .init(stepIndex: 2, keywords: ["인간지성", "enquiry", "종교", "대화", "해설"])
            ]
        case .rousseau:
            return [
                .init(stepIndex: 0, keywords: ["입문", "개론", "guide"]),
                .init(stepIndex: 1, keywords: ["사회계약론", "social contract", "에밀", "emile"]),
                .init(stepIndex: 2, keywords: ["불평등", "discourse", "고백록", "해설"])
            ]
        case .kant:
            return [
                .init(stepIndex: 0, keywords: ["입문", "가이드", "guide"]),
                .init(stepIndex: 1, keywords: ["순수이성비판", "critique of pure reason", "비판철학"]),
                .init(stepIndex: 2, keywords: ["실천이성", "판단력", "도덕형이상학", "해설"])
            ]

        // 19th
        case .marx:
            return [
                .init(stepIndex: 0, keywords: ["입문", "개론", "guide"]),
                .init(stepIndex: 1, keywords: ["공산당 선언", "manifesto", "독일 이데올로기", "유물론"]),
                .init(stepIndex: 2, keywords: ["자본", "capital", "정치경제학", "경제학비판"])
            ]
        case .hegel:
            return [
                .init(stepIndex: 0, keywords: ["입문", "개론", "guide"]),
                .init(stepIndex: 1, keywords: ["정신현상학", "phenomenology", "논리학", "logic"]),
                .init(stepIndex: 2, keywords: ["법철학", "역사철학", "강의", "해설"])
            ]
        case .nietzsche:
            return [
                .init(stepIndex: 0, keywords: ["입문", "개론", "guide"]),
                .init(stepIndex: 1, keywords: ["차라투스트라", "zarathustra", "선악의 저편", "beyond good and evil"]),
                .init(stepIndex: 2, keywords: ["도덕의 계보", "genealogy", "우상의 황혼", "해설"])
            ]
        case .kierkegaard:
            return [
                .init(stepIndex: 0, keywords: ["입문", "개론", "guide"]),
                .init(stepIndex: 1, keywords: ["죽음에 이르는 병", "불안의 개념", "병", "anxiety"]),
                .init(stepIndex: 2, keywords: ["철학적 단편", "사랑의 역사", "해설"])
            ]
        }
    }

    static func classify(book: BookItem, philosopher: Philosopher) -> Int {
        let text = ([book.title, book.author, book.description]
            .compactMap { $0 }
            .joined(separator: " ")
            .lowercased())

        let rules = rules(for: philosopher)
        var scores = Array(repeating: 0, count: 3)

        for rule in rules {
            for kw in rule.keywords {
                let needle = kw.lowercased()
                if text.contains(needle) { scores[rule.stepIndex] += 2 }
            }
        }

        // 철학자 토큰이 강하게 들어가면 전체 가중치 (기본 관련도)
        for tok in philosopher.filterTokens {
            if text.contains(tok.lowercased()) {
                scores[0] += 1; scores[1] += 1; scores[2] += 1
                break
            }
        }

        // 동점이면 step 0 -> 1 -> 2 우선
        let best = scores.enumerated().max { a, b in
            if a.element == b.element { return a.offset > b.offset }
            return a.element < b.element
        }?.offset ?? 0

        return best
    }
}
