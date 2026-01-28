import Foundation

/// 사람이 만든 '정답 로드맵' (필독 추천)
/// - 이 데이터는 추천이 비지 않게 만드는 핵심(권위/신뢰의 근거)
/// - 알라딘 API는 이 책들을 "찾아서" (표지/가격/링크/ISBN)로 보강하는 역할만 수행
struct CuratedBook: Identifiable, Hashable {
    let id = UUID()
    let philosopher: Philosopher
    let step: Int          // 1,2,3
    let title: String      // 기준 제목(대표 표기)
    let author: String     // 대표 저자 표기
    let role: String       // "입문" / "핵심" / "심화"
    let reason: String     // 왜 이 책을 이 단계에 배치하는가
    
    /// 알라딘 매칭 실패 대비 대체 표기(번역/출판사 차이 등)
    let altTitles: [String]
}

/// 큐레이션 로드맵 저장소
enum CuratedRoadmap {
    static func books(for philosopher: Philosopher) -> [CuratedBook] {
        all.filter { $0.philosopher == philosopher }
            .sorted { (a, b) in
                if a.step == b.step { return a.title < b.title }
                return a.step < b.step
            }
    }
    
    // MARK: - Data
    // 주의: 특정 번역/출판사 판본을 강제하지 않고 "작품 단위"로 추천합니다.
    static let all: [CuratedBook] = [
        // ---------------------
        // Plato
        // ---------------------
        .init(philosopher: .plato, step: 1, title: "소크라테스의 변명", author: "플라톤", role: AppConfig.roleIntroduction,
              reason: "소크라테스의 논변 방식과 철학의 출발점을 가장 짧게 이해하는 관문.",
              altTitles: ["변명", "Apology", "Apology of Socrates", "소크라테스의 변명·크리톤"]),
        .init(philosopher: .plato, step: 1, title: "크리톤", author: "플라톤", role: AppConfig.roleIntroduction,
              reason: "법·정의·시민적 의무를 둘러싼 핵심 질문을 짧은 대화로 익힐 수 있음.",
              altTitles: ["Crito", "크리톤/변명"]),
        .init(philosopher: .plato, step: 1, title: "에우튀프론", author: "플라톤", role: AppConfig.roleIntroduction,
              reason: "‘경건/정의’ 정의하기가 왜 어려운지, 대화편의 논증 리듬을 몸에 익힘.",
              altTitles: ["Euthyphro", "에우튀프론/소크라테스의 변명"]),
        .init(philosopher: .plato, step: 2, title: "국가", author: "플라톤", role: AppConfig.roleCore,
              reason: "정의·국가·영혼 구조·이데아를 한 번에 잡는 플라톤 철학의 중심축.",
              altTitles: ["국가(共和國)", "Republic", "플라톤 국가"]),
        .init(philosopher: .plato, step: 2, title: "향연", author: "플라톤", role: AppConfig.roleCore,
              reason: "사랑(에로스) 논의를 통해 ‘아름다움→이데아’로 상승하는 사유를 체감.",
              altTitles: ["Symposium", "플라톤 향연"]),
        .init(philosopher: .plato, step: 3, title: "티마이오스", author: "플라톤", role: AppConfig.roleAdvanced,
              reason: "우주론·자연철학·형이상학이 결합된 난해한 대화편. 핵심 저작 이해 후 도전.",
              altTitles: ["Timaeus", "플라톤 티마이오스"]),
        .init(philosopher: .plato, step: 3, title: "법률", author: "플라톤", role: AppConfig.roleAdvanced,
              reason: "이상국가에서 실제 제도 설계로 이동하며, 후기 플라톤의 현실 감각을 확인.",
              altTitles: ["Laws", "플라톤 법률"]),
        
        // ---------------------
        // Aristotle
        // ---------------------
            .init(philosopher: .aristotle, step: 1, title: "니코마코스 윤리학", author: "아리스토텔레스", role: AppConfig.roleIntroduction,
                  reason: "덕·행복·습관 개념으로 아리스토텔레스의 사고방식을 가장 직관적으로 익힘.",
                  altTitles: ["윤리학", "Nicomachean Ethics", "니코마코스윤리학"]),
        .init(philosopher: .aristotle, step: 1, title: "정치학", author: "아리스토텔레스", role: AppConfig.roleIntroduction,
              reason: "윤리학과 이어지는 ‘좋은 삶/좋은 공동체’ 논의를 통해 전체 그림을 잡기 좋음.",
              altTitles: ["Politics", "아리스토텔레스 정치학"]),
        .init(philosopher: .aristotle, step: 1, title: "시학", author: "아리스토텔레스", role: AppConfig.roleIntroduction,
              reason: "짧지만 강력한 텍스트. 개념 정의 방식(원인/구조)을 맛보기로 좋음.",
              altTitles: ["Poetics", "아리스토텔레스 시학"]),
        .init(philosopher: .aristotle, step: 2, title: "범주론", author: "아리스토텔레스", role: AppConfig.roleCore,
              reason: "논리학 입문. ‘개념을 분류하는 방식’이 이후 텍스트 전반의 문법이 됨.",
              altTitles: ["Categories", "범주론/해석에 대하여"]),
        .init(philosopher: .aristotle, step: 2, title: "해석에 대하여", author: "아리스토텔레스", role: AppConfig.roleCore,
              reason: "명제·부정·필연 등 논리적 구조를 다룸. 오르가논의 대표 관문.",
              altTitles: ["On Interpretation", "De Interpretatione"]),
        .init(philosopher: .aristotle, step: 3, title: "형이상학", author: "아리스토텔레스", role: AppConfig.roleAdvanced,
              reason: "‘존재를 존재로서’ 탐구. 가장 핵심이면서도 난해한 본령.",
              altTitles: ["Metaphysics", "아리스토텔레스 형이상학"]),
        .init(philosopher: .aristotle, step: 3, title: "자연학", author: "아리스토텔레스", role: AppConfig.roleAdvanced,
              reason: "변화·운동·원인을 통해 자연 세계의 철학적 설명을 제공.",
              altTitles: ["Physics", "아리스토텔레스 자연학"]),
        .init(philosopher: .aristotle, step: 3, title: "영혼에 대하여", author: "아리스토텔레스", role: AppConfig.roleAdvanced,
              reason: "심리·인식·생명 이해의 고전. 형이상학/자연학과 연결되는 핵심 텍스트.",
              altTitles: ["De Anima", "On the Soul"]),
        
        // ---------------------
        // Augustine
        // ---------------------
            .init(philosopher: .augustine, step: 1, title: "고백록", author: "아우구스티누스", role: AppConfig.roleIntroduction,
                  reason: "내면 성찰과 회심의 서사로 중세 철학의 출발 감각을 가장 잘 익힘.",
                  altTitles: ["Confessions", "아우구스티누스 고백록"]),
        .init(philosopher: .augustine, step: 1, title: "교사론", author: "아우구스티누스", role: AppConfig.roleIntroduction,
              reason: "언어/기억/가르침을 통해 인식론적 핵심 문제로 자연스럽게 진입.",
              altTitles: ["De Magistro", "On the Teacher"]),
        .init(philosopher: .augustine, step: 2, title: "신국론", author: "아우구스티누스", role: AppConfig.roleCore,
              reason: "역사·정치·신학이 엮인 거대 텍스트. 중세 사유의 틀을 잡는 핵심.",
              altTitles: ["City of God", "De Civitate Dei"]),
        .init(philosopher: .augustine, step: 2, title: "자유의지론", author: "아우구스티누스", role: AppConfig.roleCore,
              reason: "악과 자유의지 문제를 체계적으로 다룸. 이후 스콜라 논쟁의 출발점.",
              altTitles: ["On Free Choice of the Will", "De libero arbitrio"]),
        .init(philosopher: .augustine, step: 3, title: "삼위일체론", author: "아우구스티누스", role: AppConfig.roleAdvanced,
              reason: "가장 난도 높은 신학/형이상학 텍스트. 핵심 논점을 잡은 뒤 도전.",
              altTitles: ["On the Trinity", "De Trinitate"]),
        
        // ---------------------
        // Anselm
        // ---------------------
            .init(philosopher: .anselm, step: 1, title: "프로슬로기온", author: "안셀무스", role: AppConfig.roleIntroduction,
                  reason: "존재론적 논증의 핵심 텍스트. 중세 논증 스타일을 짧게 체험.",
                  altTitles: ["Proslogion", "프로슬로기온/모놀로기온"]),
        .init(philosopher: .anselm, step: 1, title: "모놀로기온", author: "안셀무스", role: AppConfig.roleIntroduction,
              reason: "하나의 원리로 신을 사유하려는 시도. 논증 흐름 연습에 좋음.",
              altTitles: ["Monologion"]),
        .init(philosopher: .anselm, step: 2, title: "왜 신이 인간이 되었는가", author: "안셀무스", role: AppConfig.roleCore,
              reason: "속죄/구원 논의의 고전. 신학이 철학적 논증으로 전개되는 방식을 보여줌.",
              altTitles: ["Cur Deus Homo", "왜 신이 사람이 되었는가"]),
        .init(philosopher: .anselm, step: 3, title: "안셀무스 선집", author: "안셀무스", role: AppConfig.roleAdvanced,
              reason: "논증 텍스트들을 묶어 읽으면 스콜라 논리 문법이 빠르게 잡힘.",
              altTitles: ["Anselm", "안셀무스"]),
        
        // ---------------------
        // Aquinas
        // ---------------------
            .init(philosopher: .aquinas, step: 1, title: "토마스 아퀴나스 입문", author: "토마스 아퀴나스", role: AppConfig.roleIntroduction,
                  reason: "신학대전 완독은 부담이 크므로, 먼저 핵심 개념 지도를 확보.",
                  altTitles: ["아퀴나스 입문", "Aquinas introduction", "토마스 아퀴나스"]),
        .init(philosopher: .aquinas, step: 2, title: "신학대전", author: "토마스 아퀴나스", role: AppConfig.roleCore,
              reason: "중세 스콜라의 정점. 발췌/해설과 함께 읽는 것을 전제한 핵심 본문.",
              altTitles: ["Summa Theologiae", "신학대전(발췌)", "토마스 아퀴나스 신학대전"]),
        .init(philosopher: .aquinas, step: 2, title: "존재와 본질에 대하여", author: "토마스 아퀴나스", role: AppConfig.roleCore,
              reason: "형이상학의 핵심 논점(존재/본질)을 짧게 압축해 다루는 대표 텍스트.",
              altTitles: ["De ente et essentia", "On Being and Essence"]),
        .init(philosopher: .aquinas, step: 3, title: "아리스토텔레스 주석", author: "토마스 아퀴나스", role: AppConfig.roleAdvanced,
              reason: "아리스토텔레스 수용이 어떻게 스콜라로 재구성되는지 확인하는 고급 단계.",
              altTitles: ["Commentary", "아퀴나스 주석", "Aquinas commentary"]),
        // ---------------------
        // Boethius
        // ---------------------
            .init(philosopher: .boethius, step: 1, title: "철학의 위안", author: "보에티우스", role: AppConfig.roleIntroduction,
                  reason: "고대에서 중세로 넘어가는 교량 텍스트. 운명·행복·선의 문제를 종합적으로 다룸.",
                  altTitles: ["Consolation of Philosophy", "The Consolation of Philosophy", "보에티우스 철학의 위안"]),
        .init(philosopher: .boethius, step: 2, title: "신학 소논문집", author: "보에티우스", role: AppConfig.roleCore,
              reason: "개념 정의와 논증 방식이 스콜라 문법으로 이어지는 지점을 확인.",
              altTitles: ["Opuscula Sacra", "보에티우스 신학 소논문"]),
        
        // ---------------------
        // Avicenna (Ibn Sina)
        // ---------------------
            .init(philosopher: .avicenna, step: 1, title: "아비센나 입문", author: "이븐 시나(아비센나)", role: AppConfig.roleIntroduction,
                  reason: "이슬람 철학의 큰 지도를 먼저 잡고, 존재론 핵심 개념으로 들어가기 위한 진입로.",
                  altTitles: ["Avicenna introduction", "이븐 시나 입문", "아비센나"]),
        .init(philosopher: .avicenna, step: 2, title: "치유의 서(형이상학)", author: "이븐 시나(아비센나)", role: AppConfig.roleCore,
              reason: "필연/가능 존재, 본질/존재 구분 등 중세 존재론의 핵심 논점을 제공.",
              altTitles: ["The Book of Healing", "al-Shifa", "샤파", "치유의 서"]),
        
        // ---------------------
        // Averroes (Ibn Rushd)
        // ---------------------
            .init(philosopher: .averroes, step: 1, title: "아베로에스 입문", author: "이븐 루시드(아베로에스)", role: AppConfig.roleIntroduction,
                  reason: "아리스토텔레스 해석 전통을 이해하기 위한 진입. ‘이성’의 위상을 둘러싼 논쟁의 중심.",
                  altTitles: ["Averroes introduction", "이븐 루시드 입문", "아베로에스"]),
        .init(philosopher: .averroes, step: 2, title: "아리스토텔레스 주석(선집)", author: "이븐 루시드(아베로에스)", role: AppConfig.roleCore,
              reason: "고대 철학이 중세에서 어떻게 재구성되는지 가장 직접적으로 보여줌.",
              altTitles: ["Commentary", "주석", "Averroes commentary"]),
        
        // ---------------------
        // Duns Scotus
        // ---------------------
            .init(philosopher: .dunsScotus, step: 1, title: "둔스 스코투스 입문", author: "둔스 스코투스", role: AppConfig.roleIntroduction,
                  reason: "스콜라 후반의 논점(개별성/형이상학)을 이해하기 위한 지도 확보.",
                  altTitles: ["Duns Scotus introduction", "스코투스 입문", "Scotus"]),
        .init(philosopher: .dunsScotus, step: 2, title: "형이상학에 관한 강해(선집)", author: "둔스 스코투스", role: AppConfig.roleCore,
              reason: "존재 개념을 정교화하고, 후대 형이상학 논쟁의 한 축을 형성.",
              altTitles: ["Ordinatio", "Reportatio", "Scotus metaphysics"]),
        
        // ---------------------
        // Ockham
        // ---------------------
            .init(philosopher: .ockham, step: 1, title: "오컴 입문", author: "오컴", role: AppConfig.roleIntroduction,
                  reason: "명목론과 방법론적 전환을 이해하기 위한 출발점.",
                  altTitles: ["Ockham introduction", "오컴의 면도날", "Ockham"]),
        .init(philosopher: .ockham, step: 2, title: "오컴 논리학(선집)", author: "오컴", role: AppConfig.roleCore,
              reason: "보편자 논쟁의 결론부를 형성하는 핵심 논의.",
              altTitles: ["Summa Logicae", "논리학 대전", "오컴 논리학"]),
        
        // ---------------------
        // Descartes
        // ---------------------
            .init(philosopher: .descartes, step: 1, title: "방법서설", author: "데카르트", role: AppConfig.roleIntroduction,
                  reason: "근대 철학의 출발: 방법, 회의, 확실성의 기준을 가장 읽기 쉬운 형태로 제시.",
                  altTitles: ["Discourse on Method", "방법서설/성찰", "데카르트 방법서설"]),
        .init(philosopher: .descartes, step: 2, title: "성찰", author: "데카르트", role: AppConfig.roleCore,
              reason: "자아·신·세계에 대한 근대 인식론/형이상학의 핵심 논증이 전개됨.",
              altTitles: ["Meditations", "Meditations on First Philosophy", "제1철학에 관한 성찰", "성찰(제1철학)"]),
        .init(philosopher: .descartes, step: 3, title: "정념론", author: "데카르트", role: AppConfig.roleAdvanced,
              reason: "심리·정서·몸-마음 관계를 다루며 근대 인간학으로 확장.",
              altTitles: ["Passions of the Soul", "정념론/영혼의 정념"]),
        
        // ---------------------
        // Spinoza
        // ---------------------
            .init(philosopher: .spinoza, step: 1, title: "스피노자 입문", author: "스피노자", role: AppConfig.roleIntroduction,
                  reason: "일원론·실체 개념과 기하학적 전개 방식을 읽기 전에 지도부터 확보.",
                  altTitles: ["Spinoza introduction", "스피노자 가이드", "스피노자"]),
        .init(philosopher: .spinoza, step: 2, title: "윤리학", author: "스피노자", role: AppConfig.roleCore,
              reason: "기하학적 방법으로 실체·정서·자유를 전개하는 대표 저작(난도 높음).",
              altTitles: ["Ethics", "Ethica", "스피노자 윤리학"]),
        .init(philosopher: .spinoza, step: 3, title: "신학정치론", author: "스피노자", role: AppConfig.roleAdvanced,
              reason: "종교·성서 해석·정치 질서를 둘러싼 논쟁 텍스트로 사상 적용을 확장.",
              altTitles: ["Theological-Political Treatise", "Tractatus Theologico-Politicus", "신학-정치론"]),
        // ---------------------
        // Locke
        // ---------------------
            .init(philosopher: .locke, step: 1, title: "로크 입문", author: "로크", role: AppConfig.roleIntroduction,
                  reason: "경험론·인식론·정치철학의 큰 지도를 먼저 잡아 이후 원전 독해를 쉽게 함.",
                  altTitles: ["Locke introduction", "로크 가이드", "존 로크 입문"]),
        .init(philosopher: .locke, step: 2, title: "인간 오성에 관한 시론", author: "로크", role: "핵심",
              reason: "관념·지식·언어 등 경험론 인식론의 핵심 구조를 가장 체계적으로 제시.",
              altTitles: ["An Essay Concerning Human Understanding", "Essay Concerning Human Understanding", "인간오성론"]),
        .init(philosopher: .locke, step: 3, title: "정부론(통치론)", author: "로크", role: AppConfig.roleAdvanced,
              reason: "자유·재산·정당한 권력의 근거를 다루는 근대 정치철학의 대표 고전.",
              altTitles: ["Two Treatises of Government", "Second Treatise of Government", "통치론", "Two Treatises"]),
        
        // ---------------------
        // Leibniz
        // ---------------------
            .init(philosopher: .leibniz, step: 1, title: "라이프니츠 입문", author: "라이프니츠", role: AppConfig.roleIntroduction,
                  reason: "단자론·합리론·형이상학 논점(실체/가능세계)을 읽기 전 지도 확보.",
                  altTitles: ["Leibniz introduction", "라이프니츠 가이드", "라이프니츠"]),
        .init(philosopher: .leibniz, step: 2, title: "단자론", author: "라이프니츠", role: AppConfig.roleCore,
              reason: "라이프니츠 형이상학의 핵심(단자·조화·표상)을 가장 압축적으로 제시하는 텍스트.",
              altTitles: ["Monadology", "모나돌로지", "단자론/형이상학 서설"]),
        .init(philosopher: .leibniz, step: 3, title: "신정론", author: "라이프니츠", role: AppConfig.roleAdvanced,
              reason: "악·자유·최선의 가능세계 논의를 통해 단자론의 적용과 논쟁점을 깊게 이해.",
              altTitles: ["Theodicy", "Essays on the Goodness of God", "라이프니츠 신정론"]),
        
        // ---------------------
        // Hegel
        // ---------------------
            .init(philosopher: .hegel, step: 1, title: "헤겔 입문", author: "헤겔", role: AppConfig.roleIntroduction,
                  reason: "변증법·정신·역사 개념을 지도처럼 먼저 잡아야 원전에서 길을 잃지 않음.",
                  altTitles: ["Hegel introduction", "헤겔 가이드", "헤겔"]),
        .init(philosopher: .hegel, step: 2, title: "정신현상학", author: "헤겔", role: AppConfig.roleCore,
              reason: "의식의 전개를 따라가며 변증법의 ‘작동 방식’을 가장 강하게 체감하는 대표 저작.",
              altTitles: ["Phenomenology of Spirit", "Phenomenology of Mind", "정신 현상학"]),
        .init(philosopher: .hegel, step: 3, title: "법철학", author: "헤겔", role: AppConfig.roleAdvanced,
              reason: "윤리·국가·자유 개념이 제도/역사와 결합되는 지점까지 확장해 이해를 완성.",
              altTitles: ["Elements of the Philosophy of Right", "Philosophy of Right", "법철학 강요"]),
        
        // ---------------------
        // Nietzsche
        // ---------------------
            .init(philosopher: .nietzsche, step: 1, title: "니체 입문", author: "니체", role: AppConfig.roleIntroduction,
                  reason: "힘/가치/도덕 비판의 핵심 문제의식을 먼저 정리하면 원전이 훨씬 선명해짐.",
                  altTitles: ["Nietzsche introduction", "니체 가이드", "니체"]),
        .init(philosopher: .nietzsche, step: 2, title: "선악의 저편", author: "니체", role: AppConfig.roleCore,
              reason: "도덕·진리·철학 자체를 겨냥한 비판이 압축적으로 전개되는 핵심 텍스트.",
              altTitles: ["Beyond Good and Evil", "BGE", "선악의 저편/도덕의 계보"]),
        .init(philosopher: .nietzsche, step: 3, title: "도덕의 계보", author: "니체", role: AppConfig.roleAdvanced,
              reason: "가치의 기원과 도덕 감정의 형성을 ‘계보학’으로 해부해 니체 사유를 깊게 고정.",
              altTitles: ["On the Genealogy of Morality", "Genealogy of Morals", "도덕 계보학"]),
        
        // ---------------------
        // Kierkegaard
        // ---------------------
            .init(philosopher: .kierkegaard, step: 1, title: "키르케고르 입문", author: "키르케고르", role: AppConfig.roleIntroduction,
                  reason: "실존·불안·신앙의 핵심 테마와 문체를 먼저 이해하면 원전 난도가 크게 내려감.",
                  altTitles: ["Kierkegaard introduction", "키르케고르 가이드", "키르케고르"]),
        .init(philosopher: .kierkegaard, step: 2, title: "불안의 개념", author: "키르케고르", role: AppConfig.roleCore,
              reason: "불안·자유·가능성 개념을 통해 실존철학의 문제 구도를 가장 잘 잡아줌.",
              altTitles: ["The Concept of Anxiety", "불안 개념", "불안의 개념(개정)"]),
        .init(philosopher: .kierkegaard, step: 3, title: "죽음에 이르는 병", author: "키르케고르", role: AppConfig.roleAdvanced,
              reason: "절망 분석을 통해 ‘자기’와 ‘신앙’의 관계를 가장 정교하게 파고드는 대표 저작.",
              altTitles: ["The Sickness Unto Death", "Sickness Unto Death", "죽음에 이르는 병(절망)"]),
        
        
        
        
        // ---------------------
        // Hume (18th century, but included in '근대')
        // ---------------------
            .init(philosopher: .hume, step: 1, title: "흄 입문", author: "흄", role: AppConfig.roleIntroduction,
                  reason: "인과·자아·귀납 문제로 이어지는 핵심 논점을 먼저 정리.",
                  altTitles: ["Hume introduction", "흄 가이드", "흄"]),
        .init(philosopher: .hume, step: 2, title: "인간 본성에 관한 논고", author: "흄", role: AppConfig.roleCore,
              reason: "흄 경험론의 정점. 길고 난해하지만 전체 체계를 가장 직접적으로 제시.",
              altTitles: ["A Treatise of Human Nature", "Treatise", "인성론"]),
        .init(philosopher: .hume, step: 3, title: "인간 지성에 관한 탐구", author: "흄", role: AppConfig.roleAdvanced,
              reason: "논고를 압축/개정한 형태로 핵심 논증을 빠르게 복습·정리 가능.",
              altTitles: ["An Enquiry Concerning Human Understanding", "Enquiry", "탐구"]),
        
        // ---------------------
        // Rousseau (18th century)
        // ---------------------
            .init(philosopher: .rousseau, step: 1, title: "루소 입문", author: "루소", role: AppConfig.roleIntroduction,
                  reason: "근대 정치철학의 문제의식(자연상태/시민/불평등)을 지도부터 잡기.",
                  altTitles: ["Rousseau introduction", "루소 가이드", "루소"]),
        .init(philosopher: .rousseau, step: 2, title: "사회계약론", author: "루소", role: AppConfig.roleCore,
              reason: "정치적 정당성의 근거를 ‘일반의지’로 세우는 대표 저작.",
              altTitles: ["The Social Contract", "Social Contract", "사회 계약론"]),
        .init(philosopher: .rousseau, step: 3, title: "에밀", author: "루소", role: AppConfig.roleAdvanced,
              reason: "교육·인간 형성의 관점에서 루소의 정치/도덕 철학을 확장.",
              altTitles: ["Emile", "Émile", "에밀(교육론)"]),
        
        // ---------------------
        // Kant (18th century)
        // ---------------------
            .init(philosopher: .kant, step: 1, title: "칸트 입문", author: "칸트", role: AppConfig.roleIntroduction,
                  reason: "비판철학의 용어(선험, 범주, 현상/물자체)를 먼저 정리.",
                  altTitles: ["Kant introduction", "칸트 가이드", "칸트"]),
        .init(philosopher: .kant, step: 2, title: "순수이성비판", author: "칸트", role: AppConfig.roleCore,
              reason: "근대 인식론의 전환점. 난도 높으므로 해설/강의와 병행 추천.",
              altTitles: ["Critique of Pure Reason", "CPR", "순수 이성 비판"]),
        .init(philosopher: .kant, step: 3, title: "실천이성비판", author: "칸트", role: AppConfig.roleAdvanced,
              reason: "도덕·자유·실천 이성을 통해 비판철학의 두 축(인식/윤리)을 완성.",
              altTitles: ["Critique of Practical Reason", "실천 이성 비판"]),
        
        // ---------------------
        // Marx (19th century)
        // ---------------------
            .init(philosopher: .marx, step: 1, title: "마르크스 입문", author: "마르크스", role: AppConfig.roleIntroduction,
                  reason: "역사유물론·자본주의 분석의 문제의식을 먼저 잡고 들어가기 위한 지침서.",
                  altTitles: ["Marx introduction", "마르크스 가이드", "마르크스"]),
        .init(philosopher: .marx, step: 2, title: "공산당 선언", author: "마르크스", role: AppConfig.roleCore,
              reason: "짧지만 핵심이 집약된 정치적 텍스트. 이후 저작들의 문제의식을 선명히 함.",
              altTitles: ["Communist Manifesto", "Manifesto", "공산당 선언문"]),
        .init(philosopher: .marx, step: 3, title: "자본", author: "마르크스", role: AppConfig.roleAdvanced,
              reason: "정치경제학 비판의 본체. 방대하므로 해설/강의 병행 권장.",
              altTitles: ["Capital", "Das Kapital", "자본론"]),
    ]
}
