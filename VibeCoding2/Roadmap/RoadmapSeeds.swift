import Foundation

// Hardcoded curation ("전문가 의견 위주")
// - 20명 내외 작가
// - 작가별 3단계 (입문/핵심/심화)
// - 각 단계에 빈 내용 없음 (책/코멘트 포함)

struct RoadmapAuthor: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let nationality: String
    let era: String
    /// Overall reading difficulty for this author's roadmap.
    /// Defaults to .medium so existing seeds remain valid, but many authors override this.
    var difficulty: RoadmapDifficulty = .medium
    let tagline: String
    let steps: [RoadmapStep]
}

enum RoadmapDifficulty: String, Codable, CaseIterable, Identifiable {
    case easy = "쉬움"
    case medium = "보통"
    case hard = "어려움"
    
    var id: String { rawValue }
    
    /// Sorting weight (easy -> hard)
    var sortOrder: Int {
        switch self {
        case .easy: return 0
        case .medium: return 1
        case .hard: return 2
        }
    }
}

struct RoadmapStep: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let purpose: String
    let books: [BookSeed]
}

struct BookSeed: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let author: String
    let why: String
    
    /// Query sent to Aladin ItemSearch (Keyword)
    var query: String { "\(title) \(author)" }
}

enum RoadmapSeeds {
    static let authors: [RoadmapAuthor] = [
        // 1 Dostoevsky
        RoadmapAuthor(
            id: "dostoevsky",
            name: "표도르 도스토예프스키",
            nationality: "러시아",
            era: "19세기",
            difficulty: .hard,
            tagline: "죄책감, 자유, 신앙과 허무를 정면으로 붙잡는 심리 소설의 거장",
            steps: [
                RoadmapStep(
                    id: "dostoevsky-1",
                    title: "Step 1 · 입문",
                    purpose: "도스토예프스키의 '문제의식'을 부담 없이 맛보기",
                    books: [
                        BookSeed(id: "dost-wn", title: "백야", author: "도스토예프스키", why: "짧고 선명한 감정선으로 문체에 익숙해지기"),
                        BookSeed(id: "dost-poor", title: "가난한 사람들", author: "도스토예프스키", why: "초기작의 사회성·연민을 확인"),
                        BookSeed(id: "dost-notes", title: "지하로부터의 수기", author: "도스토예프스키", why: "자기혐오/자기정당화의 엔진을 압축해서 체감")
                    ]
                ),
                RoadmapStep(
                    id: "dostoevsky-2",
                    title: "Step 2 · 핵심",
                    purpose: "주요 테마(죄/심판/구원)의 대표작으로 본격 진입",
                    books: [
                        BookSeed(id: "dost-cp", title: "죄와 벌", author: "도스토예프스키", why: "도덕·이성의 논리와 무너짐을 가장 대중적으로 보여줌"),
                        BookSeed(id: "dost-idiot", title: "백치", author: "도스토예프스키", why: "'선함'이 사회에서 어떻게 파괴되는지 실험"),
                        BookSeed(id: "dost-demons", title: "악령", author: "도스토예프스키", why: "이념·허무주의가 인간을 어떻게 잠식하는지 드라마로")
                    ]
                ),
                RoadmapStep(
                    id: "dostoevsky-3",
                    title: "Step 3 · 심화",
                    purpose: "도스토예프스키의 세계관 총합(종교·윤리·인간학)"
                    ,
                    books: [
                        BookSeed(id: "dost-k", title: "카라마조프가의 형제들", author: "도스토예프스키", why: "신·악·자유의 문제를 인물 군상으로 총집합"),
                        BookSeed(id: "dost-house", title: "죽음의 집의 기록", author: "도스토예프스키", why: "수용소 경험 기반, 인간 이해의 저변을 확장"),
                        BookSeed(id: "dost-teen", title: "미성년", author: "도스토예프스키", why: "욕망/가족/정체성의 어긋남을 긴 호흡으로")
                    ]
                )
            ]
        ),
        
        // 2 Tolstoy
        RoadmapAuthor(
            id: "tolstoy",
            name: "레프 톨스토이",
            nationality: "러시아",
            era: "19세기",
            difficulty: .hard,
            tagline: "삶의 윤리와 공동체를 거대한 리얼리즘으로 밀어붙인 작가",
            steps: [
                RoadmapStep(
                    id: "tolstoy-1",
                    title: "Step 1 · 입문",
                    purpose: "짧은 형식에서 톨스토이의 도덕 감각과 필력을 확인",
                    books: [
                        BookSeed(id: "tol-ivan", title: "이반 일리치의 죽음", author: "톨스토이", why: "삶의 진정성/죽음의 각성을 가장 농축한 중편"),
                        BookSeed(id: "tol-family", title: "가정의 행복", author: "톨스토이", why: "관계의 온도 변화와 심리 묘사에 익숙해지기"),
                        BookSeed(id: "tol-haji", title: "하지 무라트", author: "톨스토이", why: "역사·권력·개인의 비극을 간결하게")
                    ]
                ),
                RoadmapStep(
                    id: "tolstoy-2",
                    title: "Step 2 · 핵심",
                    purpose: "대작에서 톨스토이 리얼리즘의 스케일을 체감",
                    books: [
                        BookSeed(id: "tol-anna", title: "안나 카레니나", author: "톨스토이", why: "사랑·도덕·사회 규범의 충돌을 가장 정교하게"),
                        BookSeed(id: "tol-war", title: "전쟁과 평화", author: "톨스토이", why: "역사 속 개인의 의미를 서사로 밀어붙임"),
                        BookSeed(id: "tol-res", title: "부활", author: "톨스토이", why: "죄책감과 사회 정의를 결말까지 몰아침")
                    ]
                ),
                RoadmapStep(
                    id: "tolstoy-3",
                    title: "Step 3 · 심화",
                    purpose: "후기 사상·윤리 글로 톨스토이의 '결론'을 확인",
                    books: [
                        BookSeed(id: "tol-conf", title: "참회", author: "톨스토이", why: "삶의 목적을 스스로 해부한 기록"),
                        BookSeed(id: "tol-king", title: "사람은 무엇으로 사는가", author: "톨스토이", why: "도덕 우화로 핵심 메시지를 반복 학습"),
                        BookSeed(id: "tol-gospel", title: "나의 신앙", author: "톨스토이", why: "종교·윤리 관점을 직접 확인")
                    ]
                )
            ]
        ),
        
        // 3 Franz Kafka
        RoadmapAuthor(
            id: "kafka",
            name: "프란츠 카프카",
            nationality: "체코(독일어권)",
            era: "20세기 초",
            difficulty: .hard,
            tagline: "부조리한 시스템과 불안을 '꿈의 논리'로 현실화",
            steps: [
                RoadmapStep(
                    id: "kafka-1",
                    title: "Step 1 · 입문",
                    purpose: "카프카적 분위기(불안/부조리)의 기초를 짧게",
                    books: [
                        BookSeed(id: "kaf-metamorph", title: "변신", author: "카프카", why: "카프카 세계로 들어가는 가장 강력한 한 방"),
                        BookSeed(id: "kaf-penal", title: "형벌 식민지", author: "카프카", why: "권력·규율의 폭력성을 압축"),
                        BookSeed(id: "kaf-country", title: "시골의사", author: "카프카", why: "단편에서 기묘한 인과와 감각에 익숙해지기")
                    ]
                ),
                RoadmapStep(
                    id: "kafka-2",
                    title: "Step 2 · 핵심",
                    purpose: "대표 장편으로 '시스템'의 공포를 본격 체험",
                    books: [
                        BookSeed(id: "kaf-trial", title: "소송", author: "카프카", why: "이유 없는 죄책과 절차의 미로"),
                        BookSeed(id: "kaf-castle", title: "성", author: "카프카", why: "접근 불가능한 권위의 상징"),
                        BookSeed(id: "kaf-hunger", title: "단식광대", author: "카프카", why: "타인 시선과 자기 소멸의 드라마")
                    ]
                ),
                RoadmapStep(
                    id: "kafka-3",
                    title: "Step 3 · 심화",
                    purpose: "편지/아포리즘으로 카프카의 내면과 사유를 보강",
                    books: [
                        BookSeed(id: "kaf-diary", title: "카프카 일기", author: "카프카", why: "작품의 불안이 만들어지는 공정을 확인"),
                        BookSeed(id: "kaf-letter", title: "아버지에게 드리는 편지", author: "카프카", why: "권위/죄책감의 근원을 직접 서술"),
                        BookSeed(id: "kaf-parables", title: "우화와 단편", author: "카프카", why: "짧은 텍스트에서 주제 반복 학습")
                    ]
                )
            ]
        ),
        
        // 4 Albert Camus
        RoadmapAuthor(
            id: "camus",
            name: "알베르 카뮈",
            nationality: "프랑스",
            era: "20세기",
            difficulty: .medium,
            tagline: "부조리 속에서도 '살아가기'를 선택하는 문장",
            steps: [
                RoadmapStep(
                    id: "camus-1",
                    title: "Step 1 · 입문",
                    purpose: "부조리 감각을 서사로 쉽게 체감",
                    books: [
                        BookSeed(id: "cam-stranger", title: "이방인", author: "카뮈", why: "부조리의 체온을 가장 대중적으로"),
                        BookSeed(id: "cam-exile", title: "추방과 왕국", author: "카뮈", why: "단편으로 다양한 변주를 접하기"),
                        BookSeed(id: "cam-fall", title: "전락", author: "카뮈", why: "자기고백 형식으로 죄책과 위선을 해부")
                    ]
                ),
                RoadmapStep(
                    id: "camus-2",
                    title: "Step 2 · 핵심",
                    purpose: "윤리와 공동체의 질문으로 확장",
                    books: [
                        BookSeed(id: "cam-plague", title: "페스트", author: "카뮈", why: "연대/책임을 서사적 알레고리로"),
                        BookSeed(id: "cam-rebel", title: "반항하는 인간", author: "카뮈", why: "부조리 이후의 정치·윤리 사유"),
                        BookSeed(id: "cam-sisy", title: "시지프 신화", author: "카뮈", why: "카뮈 철학의 핵심 문장들을 직접")
                    ]
                ),
                RoadmapStep(
                    id: "camus-3",
                    title: "Step 3 · 심화",
                    purpose: "극작/산문으로 카뮈의 스펙트럼 확장",
                    books: [
                        BookSeed(id: "cam-cali", title: "칼리굴라", author: "카뮈", why: "부조리 권력의 극적 실험"),
                        BookSeed(id: "cam-just", title: "정의로운 사람들", author: "카뮈", why: "정의/폭력의 경계 질문"),
                        BookSeed(id: "cam-wedding", title: "결혼·여름", author: "카뮈", why: "지중해적 감각과 생의 긍정을 읽기")
                    ]
                )
            ]
        ),
        
        // 5 George Orwell
        RoadmapAuthor(
            id: "orwell",
            name: "조지 오웰",
            nationality: "영국",
            era: "20세기",
            tagline: "권력과 언어, 감시를 파헤친 정치적 리얼리즘",
            steps: [
                RoadmapStep(
                    id: "orwell-1",
                    title: "Step 1 · 입문",
                    purpose: "오웰의 문장과 문제의식을 짧게 잡기",
                    books: [
                        BookSeed(id: "orw-animal", title: "동물농장", author: "조지 오웰", why: "권력의 변질을 가장 날카로운 우화로"),
                        BookSeed(id: "orw-essays", title: "나는 왜 쓰는가", author: "조지 오웰", why: "오웰 글쓰기 철학과 태도"),
                        BookSeed(id: "orw-burma", title: "버마 시절", author: "조지 오웰", why: "제국주의 경험의 내적 충돌")
                    ]
                ),
                RoadmapStep(
                    id: "orwell-2",
                    title: "Step 2 · 핵심",
                    purpose: "대표 디스토피아로 오웰의 핵심을 정면으로",
                    books: [
                        BookSeed(id: "orw-1984", title: "1984", author: "조지 오웰", why: "감시/언어/진실의 조작을 총합"),
                        BookSeed(id: "orw-wigan", title: "위건 부두로 가는 길", author: "조지 오웰", why: "계급 현실을 르포로"),
                        BookSeed(id: "orw-homage", title: "카탈로니아 찬가", author: "조지 오웰", why: "혁명과 현실 정치의 균열")
                    ]
                ),
                RoadmapStep(
                    id: "orwell-3",
                    title: "Step 3 · 심화",
                    purpose: "언어와 정치의 관계를 에세이로 깊게",
                    books: [
                        BookSeed(id: "orw-politics", title: "정치와 영어", author: "조지 오웰", why: "언어가 사고를 어떻게 감염시키는지"),
                        BookSeed(id: "orw-shoot", title: "코끼리를 쏘다", author: "조지 오웰", why: "권력의 강제와 자기혐오를 단편으로"),
                        BookSeed(id: "orw-ess2", title: "오웰 에세이", author: "조지 오웰", why: "대표 에세이를 묶어 '오웰식 판단' 훈련")
                    ]
                )
            ]
        ),
        
        // 6 Ernest Hemingway
        RoadmapAuthor(
            id: "hemingway",
            name: "어니스트 헤밍웨이",
            nationality: "미국",
            era: "20세기",
            tagline: "빙산 문장으로 상처와 용기를 압축하는 미니멀리즘",
            steps: [
                RoadmapStep(
                    id: "hem-1",
                    title: "Step 1 · 입문",
                    purpose: "짧은 호흡으로 헤밍웨이 문장의 감각 잡기",
                    books: [
                        BookSeed(id: "hem-old", title: "노인과 바다", author: "헤밍웨이", why: "가장 짧고 강력한 서사"),
                        BookSeed(id: "hem-men", title: "남자 없이 여자 없이", author: "헤밍웨이", why: "단편에서 빙산 이론 체감"),
                        BookSeed(id: "hem-sun", title: "태양은 다시 떠오른다", author: "헤밍웨이", why: "상실의 세대 감각과 대화체")
                    ]
                ),
                RoadmapStep(
                    id: "hem-2",
                    title: "Step 2 · 핵심",
                    purpose: "전쟁·사랑·상실의 대표 장편",
                    books: [
                        BookSeed(id: "hem-arms", title: "무기여 잘 있거라", author: "헤밍웨이", why: "전쟁과 사랑의 붕괴"),
                        BookSeed(id: "hem-bell", title: "누구를 위하여 종은 울리나", author: "헤밍웨이", why: "이념과 개인의 선택"),
                        BookSeed(id: "hem-stories", title: "헤밍웨이 단편선", author: "헤밍웨이", why: "핵심 단편을 묶어 다시 읽기")
                    ]
                ),
                RoadmapStep(
                    id: "hem-3",
                    title: "Step 3 · 심화",
                    purpose: "논픽션/후기작으로 세계관 보강",
                    books: [
                        BookSeed(id: "hem-paris", title: "파리는 날마다 축제", author: "헤밍웨이", why: "작가의 태도와 삶의 리듬"),
                        BookSeed(id: "hem-garden", title: "에덴의 동산", author: "헤밍웨이", why: "후기작의 실험적 면모"),
                        BookSeed(id: "hem-move", title: "움직이는 축제", author: "헤밍웨이", why: "창작자 관점에서 재독 가치")
                    ]
                )
            ]
        ),
        
        // 7 Jane Austen
        RoadmapAuthor(
            id: "austen",
            name: "제인 오스틴",
            nationality: "영국",
            era: "19세기",
            tagline: "사랑과 계급을 아이러니로 해부하는 고전 로맨스의 기준",
            steps: [
                RoadmapStep(
                    id: "aus-1",
                    title: "Step 1 · 입문",
                    purpose: "오스틴 특유의 풍자와 대화 리듬에 적응",
                    books: [
                        BookSeed(id: "aus-pride", title: "오만과 편견", author: "제인 오스틴", why: "가장 유명하고 읽기 쉬운 입문작"),
                        BookSeed(id: "aus-sense", title: "이성과 감성", author: "제인 오스틴", why: "감정과 규범의 균형 게임"),
                        BookSeed(id: "aus-north", title: "노생거 수도원", author: "제인 오스틴", why: "고딕 소설 패러디로 가볍게")
                    ]
                ),
                RoadmapStep(
                    id: "aus-2",
                    title: "Step 2 · 핵심",
                    purpose: "사회 관찰자 오스틴의 정교함을 확장",
                    books: [
                        BookSeed(id: "aus-emma", title: "엠마", author: "제인 오스틴", why: "자기기만과 성장의 리얼한 코미디"),
                        BookSeed(id: "aus-mansfield", title: "맨스필드 파크", author: "제인 오스틴", why: "도덕·계급·가정의 긴장"),
                        BookSeed(id: "aus-persuasion", title: "설득", author: "제인 오스틴", why: "가장 성숙한 감정선")
                    ]
                ),
                RoadmapStep(
                    id: "aus-3",
                    title: "Step 3 · 심화",
                    purpose: "비교 독서로 오스틴의 기술을 분석",
                    books: [
                        BookSeed(id: "aus-lady", title: "레이디 수전", author: "제인 오스틴", why: "서간체로 보는 사회적 연기"),
                        BookSeed(id: "aus-juvenilia", title: "오스틴 단편/소년기 작품", author: "제인 오스틴", why: "초기 필력의 에너지"),
                        BookSeed(id: "aus-crit", title: "오스틴 읽기", author: "제인 오스틴", why: "해설서로 풍자 포인트를 체계화")
                    ]
                )
            ]
        ),
        
        // 8 Charles Dickens
        RoadmapAuthor(
            id: "dickens",
            name: "찰스 디킨스",
            nationality: "영국",
            era: "19세기",
            tagline: "사회 비판과 인간미가 공존하는 스토리텔링의 달인",
            steps: [
                RoadmapStep(
                    id: "dic-1",
                    title: "Step 1 · 입문",
                    purpose: "디킨스의 유머/정서에 무리 없이 적응",
                    books: [
                        BookSeed(id: "dic-carol", title: "크리스마스 캐럴", author: "찰스 디킨스", why: "짧고 정서적, 디킨스 감각 입문"),
                        BookSeed(id: "dic-oliver", title: "올리버 트위스트", author: "찰스 디킨스", why: "사회적 약자·산문 리듬"),
                        BookSeed(id: "dic-expect", title: "위대한 유산", author: "찰스 디킨스", why: "성장 서사의 전형")
                    ]
                ),
                RoadmapStep(
                    id: "dic-2",
                    title: "Step 2 · 핵심",
                    purpose: "대작에서 도시/계급 묘사의 힘을 체감",
                    books: [
                        BookSeed(id: "dic-two", title: "두 도시 이야기", author: "찰스 디킨스", why: "혁명과 개인의 비극"),
                        BookSeed(id: "dic-bleak", title: "황폐한 집", author: "찰스 디킨스", why: "사회 구조 비판의 정점"),
                        BookSeed(id: "dic-copper", title: "데이비드 코퍼필드", author: "찰스 디킨스", why: "자전적 성장 서사")
                    ]
                ),
                RoadmapStep(
                    id: "dic-3",
                    title: "Step 3 · 심화",
                    purpose: "긴 호흡·복잡한 인물망을 통한 디킨스 완주",
                    books: [
                        BookSeed(id: "dic-friend", title: "우리 서로의 친구", author: "찰스 디킨스", why: "후기작의 정교한 플롯"),
                        BookSeed(id: "dic-times", title: "어려운 시절", author: "찰스 디킨스", why: "산업사회 비판을 응축"),
                        BookSeed(id: "dic-papers", title: "픽윅 페이퍼", author: "찰스 디킨스", why: "초기 유머 감각의 원형")
                    ]
                )
            ]
        ),
        
        // 9 Virginia Woolf
        RoadmapAuthor(
            id: "woolf",
            name: "버지니아 울프",
            nationality: "영국",
            era: "20세기",
            tagline: "의식의 흐름으로 시간과 자아를 조각하는 모더니즘",
            steps: [
                RoadmapStep(
                    id: "woo-1",
                    title: "Step 1 · 입문",
                    purpose: "울프의 리듬을 비교적 쉬운 텍스트로",
                    books: [
                        BookSeed(id: "woo-room", title: "자기만의 방", author: "버지니아 울프", why: "에세이로 문체 적응 + 주제 파악"),
                        BookSeed(id: "woo-essay", title: "보통의 독자", author: "버지니아 울프", why: "독서론을 통해 감각 익히기"),
                        BookSeed(id: "woo-orlando", title: "올랜도", author: "버지니아 울프", why: "서사적 재미가 큰 실험작")
                    ]
                ),
                RoadmapStep(
                    id: "woo-2",
                    title: "Step 2 · 핵심",
                    purpose: "대표 소설로 시간/의식의 기법을 본격 체험",
                    books: [
                        BookSeed(id: "woo-dalloway", title: "댈러웨이 부인", author: "버지니아 울프", why: "하루 속의 삶과 기억"),
                        BookSeed(id: "woo-tolight", title: "등대로", author: "버지니아 울프", why: "시간의 층위를 가장 아름답게"),
                        BookSeed(id: "woo-waves", title: "파도", author: "버지니아 울프", why: "의식의 흐름을 끝까지 밀어붙임")
                    ]
                ),
                RoadmapStep(
                    id: "woo-3",
                    title: "Step 3 · 심화",
                    purpose: "일기/비평으로 울프의 기법과 삶을 함께",
                    books: [
                        BookSeed(id: "woo-diary", title: "울프 일기", author: "버지니아 울프", why: "창작의 고민과 시대 감각"),
                        BookSeed(id: "woo-moments", title: "순간들", author: "버지니아 울프", why: "짧은 글로 밀도 높은 실험"),
                        BookSeed(id: "woo-crit", title: "버지니아 울프 비평", author: "버지니아 울프", why: "해설로 난이도 완충")
                    ]
                )
            ]
        ),
        
        // 10 Gabriel García Márquez
        RoadmapAuthor(
            id: "marquez",
            name: "가브리엘 가르시아 마르케스",
            nationality: "콜롬비아",
            era: "20세기",
            tagline: "마술적 리얼리즘으로 역사와 가족의 시간을 서사화",
            steps: [
                RoadmapStep(
                    id: "mar-1",
                    title: "Step 1 · 입문",
                    purpose: "마르케스의 문장과 리듬을 부담 없이",
                    books: [
                        BookSeed(id: "mar-chron", title: "예고된 죽음의 연대기", author: "가브리엘 가르시아 마르케스", why: "짧고 흡입력 높은 구조"),
                        BookSeed(id: "mar-colonel", title: "아무도 대령에게 편지하지 않다", author: "가브리엘 가르시아 마르케스", why: "빈곤과 기다림의 감정"),
                        BookSeed(id: "mar-stories", title: "마르케스 단편선", author: "가브리엘 가르시아 마르케스", why: "마술적 리얼리즘의 다양한 맛")
                    ]
                ),
                RoadmapStep(
                    id: "mar-2",
                    title: "Step 2 · 핵심",
                    purpose: "대표 장편으로 세계관 진입",
                    books: [
                        BookSeed(id: "mar-100", title: "백년의 고독", author: "가브리엘 가르시아 마르케스", why: "가족/역사/신화의 총합"),
                        BookSeed(id: "mar-love", title: "콜레라 시대의 사랑", author: "가브리엘 가르시아 마르케스", why: "사랑의 시간과 집착"),
                        BookSeed(id: "mar-autumn", title: "족장의 가을", author: "가브리엘 가르시아 마르케스", why: "권력과 신화적 문장의 정점")
                    ]
                ),
                RoadmapStep(
                    id: "mar-3",
                    title: "Step 3 · 심화",
                    purpose: "자전/논픽션으로 작가의 현실 감각을 보강",
                    books: [
                        BookSeed(id: "mar-memoir", title: "이야기하기 위해 살다", author: "가브리엘 가르시아 마르케스", why: "창작의 근원과 라틴아메리카 맥락"),
                        BookSeed(id: "mar-kidnap", title: "납치사건", author: "가브리엘 가르시아 마르케스", why: "르포의 힘"),
                        BookSeed(id: "mar-news", title: "한편의 기사", author: "가브리엘 가르시아 마르케스", why: "논픽션으로 보는 문장감")
                    ]
                )
            ]
        ),
        
        // 11 Haruki Murakami
        RoadmapAuthor(
            id: "murakami",
            name: "무라카미 하루키",
            nationality: "일본",
            era: "현대",
            tagline: "고독과 상실을 팝 감각으로 감싸는 현대 대중문학의 강자",
            steps: [
                RoadmapStep(
                    id: "mur-1",
                    title: "Step 1 · 입문",
                    purpose: "하루키의 리듬과 정서를 가볍게",
                    books: [
                        BookSeed(id: "mur-nor", title: "노르웨이의 숲", author: "무라카미 하루키", why: "가장 직관적인 감정 서사"),
                        BookSeed(id: "mur-south", title: "국경의 남쪽, 태양의 서쪽", author: "무라카미 하루키", why: "짧은 호흡으로 하루키식 상실"),
                        BookSeed(id: "mur-ele", title: "코끼리의 소멸", author: "무라카미 하루키", why: "단편으로 기묘한 감각 입문")
                    ]
                ),
                RoadmapStep(
                    id: "mur-2",
                    title: "Step 2 · 핵심",
                    purpose: "대표 장편에서 세계관 확장",
                    books: [
                        BookSeed(id: "mur-wind", title: "바람의 노래를 들어라", author: "무라카미 하루키", why: "초기 스타일의 원형"),
                        BookSeed(id: "mur-kafka", title: "해변의 카프카", author: "무라카미 하루키", why: "신화/꿈의 이미지가 강한 대표작"),
                        BookSeed(id: "mur-q", title: "1Q84", author: "무라카미 하루키", why: "장편 스케일에서의 서사 운용")
                    ]
                ),
                RoadmapStep(
                    id: "mur-3",
                    title: "Step 3 · 심화",
                    purpose: "에세이/장편 심화로 반복 모티프를 분석",
                    books: [
                        BookSeed(id: "mur-run", title: "달리기를 말할 때 내가 하고 싶은 이야기", author: "무라카미 하루키", why: "작가의 리듬/루틴 이해"),
                        BookSeed(id: "mur-chronicle", title: "언더그라운드", author: "무라카미 하루키", why: "논픽션으로 보는 시선"),
                        BookSeed(id: "mur-comm", title: "기사단장 죽이기", author: "무라카미 하루키", why: "후기작에서 모티프 총정리")
                    ]
                )
            ]
        ),
        
        // 12 William Shakespeare
        RoadmapAuthor(
            id: "shakespeare",
            name: "윌리엄 셰익스피어",
            nationality: "영국",
            era: "16~17세기",
            tagline: "인간 욕망의 기본형을 만든 희곡의 표준",
            steps: [
                RoadmapStep(
                    id: "sha-1",
                    title: "Step 1 · 입문",
                    purpose: "대표 비극/희극을 먼저 잡아 장벽 낮추기",
                    books: [
                        BookSeed(id: "sha-romeo", title: "로미오와 줄리엣", author: "셰익스피어", why: "서사적 친숙함으로 입문"),
                        BookSeed(id: "sha-mids", title: "한여름 밤의 꿈", author: "셰익스피어", why: "희극의 리듬과 언어 유희"),
                        BookSeed(id: "sha-mac", title: "맥베스", author: "셰익스피어", why: "권력욕과 죄책의 압축")
                    ]
                ),
                RoadmapStep(
                    id: "sha-2",
                    title: "Step 2 · 핵심",
                    purpose: "인간 내면의 극단을 대표작으로",
                    books: [
                        BookSeed(id: "sha-ham", title: "햄릿", author: "셰익스피어", why: "망설임과 사유의 드라마"),
                        BookSeed(id: "sha-lear", title: "리어 왕", author: "셰익스피어", why: "가족/권력/광기의 비극"),
                        BookSeed(id: "sha-othello", title: "오셀로", author: "셰익스피어", why: "질투와 조작의 심리")
                    ]
                ),
                RoadmapStep(
                    id: "sha-3",
                    title: "Step 3 · 심화",
                    purpose: "역사극/후기작으로 셰익스피어 스펙트럼 완성",
                    books: [
                        BookSeed(id: "sha-tempest", title: "템페스트", author: "셰익스피어", why: "후기작의 마법/화해"),
                        BookSeed(id: "sha-henry", title: "헨리 5세", author: "셰익스피어", why: "권력과 수사학"),
                        BookSeed(id: "sha-sonnets", title: "소네트", author: "셰익스피어", why: "언어의 밀도를 시로")
                    ]
                )
            ]
        ),
        
        // 13 Hermann Hesse
        RoadmapAuthor(
            id: "hesse",
            name: "헤르만 헤세",
            nationality: "독일",
            era: "20세기",
            tagline: "자기 탐색과 성장의 서사를 영성적 감수성으로",
            steps: [
                RoadmapStep(id: "hes-1", title: "Step 1 · 입문", purpose: "헤세의 '자기 탐색' 감수성을 가볍게", books: [
                    BookSeed(id: "hes-demian", title: "데미안", author: "헤르만 헤세", why: "가장 대중적인 성장소설"),
                    BookSeed(id: "hes-sidd", title: "싯다르타", author: "헤르만 헤세", why: "영적 탐색을 서사로"),
                    BookSeed(id: "hes-knulp", title: "크눌프", author: "헤르만 헤세", why: "방랑과 자유의 감정")
                ]),
                RoadmapStep(id: "hes-2", title: "Step 2 · 핵심", purpose: "자아 분열/내면의 전쟁을 깊게", books: [
                    BookSeed(id: "hes-wolf", title: "황야의 이리", author: "헤르만 헤세", why: "자아의 이중성과 현대적 고독"),
                    BookSeed(id: "hes-narz", title: "나르치스와 골드문트", author: "헤르만 헤세", why: "이성/감성의 대립"),
                    BookSeed(id: "hes-ros", title: "유리알 유희", author: "헤르만 헤세", why: "헤세 사상의 총합")
                ]),
                RoadmapStep(id: "hes-3", title: "Step 3 · 심화", purpose: "시/에세이로 헤세의 사유를 보강", books: [
                    BookSeed(id: "hes-poem", title: "헤세 시집", author: "헤르만 헤세", why: "감수성의 언어로 재학습"),
                    BookSeed(id: "hes-letter", title: "헤세 편지", author: "헤르만 헤세", why: "삶과 글의 접점"),
                    BookSeed(id: "hes-ess", title: "헤세 에세이", author: "헤르만 헤세", why: "세계관을 직접 문장으로")
                ])
            ]),
        // 14 J.D. Salinger
        RoadmapAuthor(
            id: "salinger",
            name: "J. D. 샐린저",
            nationality: "미국",
            era: "20세기",
            tagline: "청춘의 불안과 위선을 날것으로 드러낸 목소리",
            steps: [
                RoadmapStep(id: "sal-1", title: "Step 1 · 입문", purpose: "샐린저의 화법과 감정선에 익숙해지기", books: [
                    BookSeed(id: "sal-catcher", title: "호밀밭의 파수꾼", author: "샐린저", why: "청춘의 분노와 상처"),
                    BookSeed(id: "sal-nine", title: "아홉 가지 이야기", author: "샐린저", why: "단편에서 섬세한 균열"),
                    BookSeed(id: "sal-franny", title: "프래니와 주이", author: "샐린저", why: "신념·위선·구원의 긴장")
                ]),
                RoadmapStep(id: "sal-2", title: "Step 2 · 핵심", purpose: "가족 서사와 내면 독백의 확장", books: [
                    BookSeed(id: "sal-raise", title: "대들보를 높이 올려라, 목수들이여", author: "샐린저", why: "글래스 가족 세계관"),
                    BookSeed(id: "sal-symour", title: "시모어: 소개", author: "샐린저", why: "메타적 글쓰기"),
                    BookSeed(id: "sal-zooey", title: "주이", author: "샐린저", why: "대화와 고백의 밀도")
                ]),
                RoadmapStep(id: "sal-3", title: "Step 3 · 심화", purpose: "비평/해설과 함께 반복 모티프 정리", books: [
                    BookSeed(id: "sal-crit", title: "샐린저 읽기", author: "샐린저", why: "해설로 문학사적 맥락 보강"),
                    BookSeed(id: "sal-collected", title: "샐린저 단편집", author: "샐린저", why: "단편 재독으로 미세한 변화 감지"),
                    BookSeed(id: "sal-bio", title: "샐린저 평전", author: "샐린저", why: "작가의 은둔 맥락 이해")
                ])
            ]
        ),
        
        // 15 Franz Werfel? skip, use Ray Bradbury
        RoadmapAuthor(
            id: "bradbury",
            name: "레이 브래드버리",
            nationality: "미국",
            era: "20세기",
            tagline: "SF로 문명과 인간의 본능을 우아하게 비춘 작가",
            steps: [
                RoadmapStep(id: "bra-1", title: "Step 1 · 입문", purpose: "짧은 작품으로 브래드버리 감각 잡기", books: [
                    BookSeed(id: "bra-f451", title: "화씨 451", author: "레이 브래드버리", why: "검열과 독서의 의미"),
                    BookSeed(id: "bra-stories", title: "브래드버리 단편선", author: "레이 브래드버리", why: "상상력과 감정의 결"),
                    BookSeed(id: "bra-wine", title: "민들레 와인", author: "레이 브래드버리", why: "성장과 계절의 감각")
                ]),
                RoadmapStep(id: "bra-2", title: "Step 2 · 핵심", purpose: "대표 세계관으로 확장", books: [
                    BookSeed(id: "bra-mars", title: "화성 연대기", author: "레이 브래드버리", why: "식민/향수/상실"),
                    BookSeed(id: "bra-illustrated", title: "일러스트맨", author: "레이 브래드버리", why: "단편 연결구조"),
                    BookSeed(id: "bra-something", title: "사악한 것이 온다", author: "레이 브래드버리", why: "공포와 성장")
                ]),
                RoadmapStep(id: "bra-3", title: "Step 3 · 심화", purpose: "에세이/창작론으로 창작 태도까지", books: [
                    BookSeed(id: "bra-zen", title: "글쓰기의 즐거움", author: "레이 브래드버리", why: "창작 루틴과 태도"),
                    BookSeed(id: "bra-essay", title: "브래드버리 에세이", author: "레이 브래드버리", why: "문장 뒤의 철학"),
                    BookSeed(id: "bra-more", title: "브래드버리 단편집", author: "레이 브래드버리", why: "좋아하는 단편을 반복 감상")
                ])
            ]
        ),
        
        // 16 Agatha Christie
        RoadmapAuthor(
            id: "christie",
            name: "애거서 크리스티",
            nationality: "영국",
            era: "20세기",
            tagline: "추리 장르의 규칙을 대중적으로 완성한 '플롯의 여왕'",
            steps: [
                RoadmapStep(id: "chr-1", title: "Step 1 · 입문", purpose: "가장 유명한 대표작으로 재미를 먼저", books: [
                    BookSeed(id: "chr-orient", title: "오리엔트 특급 살인", author: "애거서 크리스티", why: "밀실/집단 심리"),
                    BookSeed(id: "chr-abc", title: "ABC 살인사건", author: "애거서 크리스티", why: "리듬 좋은 추리"),
                    BookSeed(id: "chr-then", title: "그리고 아무도 없었다", author: "애거서 크리스티", why: "서스펜스의 교과서")
                ]),
                RoadmapStep(id: "chr-2", title: "Step 2 · 핵심", purpose: "포와로/마플 시리즈로 규칙 익히기", books: [
                    BookSeed(id: "chr-acks", title: "로저 애크로이드 살인", author: "애거서 크리스티", why: "추리사에서 유명한 반전"),
                    BookSeed(id: "chr-nile", title: "나일 강의 죽음", author: "애거서 크리스티", why: "동기/구조의 정교함"),
                    BookSeed(id: "chr-murder", title: "살인을 예고합니다", author: "애거서 크리스티", why: "마을 공동체 추리")
                ]),
                RoadmapStep(id: "chr-3", title: "Step 3 · 심화", purpose: "연극/후기작/단편으로 확장", books: [
                    BookSeed(id: "chr-mouse", title: "쥐덫", author: "애거서 크리스티", why: "연극적 플롯"),
                    BookSeed(id: "chr-stories", title: "크리스티 단편선", author: "애거서 크리스티", why: "짧은 트릭 학습"),
                    BookSeed(id: "chr-bio", title: "애거서 크리스티 자서전", author: "애거서 크리스티", why: "작가의 세계 이해")
                ])
            ]
        ),
        
        // 17 Han Kang
        RoadmapAuthor(
            id: "hangang",
            name: "한강",
            nationality: "대한민국",
            era: "현대",
            tagline: "폭력과 침묵, 몸과 언어를 정면으로 다루는 한국문학의 대표",
            steps: [
                RoadmapStep(id: "han-1", title: "Step 1 · 입문", purpose: "한강의 정서와 문장을 비교적 빠르게", books: [
                    BookSeed(id: "han-veg", title: "채식주의자", author: "한강", why: "한강의 핵심 톤을 짧게"),
                    BookSeed(id: "han-white", title: "흰", author: "한강", why: "산문과 시 사이, 감각적 텍스트"),
                    BookSeed(id: "han-stories", title: "한강 단편집", author: "한강", why: "단편으로 주제 변주")
                ]),
                RoadmapStep(id: "han-2", title: "Step 2 · 핵심", purpose: "역사·폭력의 기억을 서사로", books: [
                    BookSeed(id: "han-boy", title: "소년이 온다", author: "한강", why: "폭력 이후의 기억과 증언"),
                    BookSeed(id: "han-human", title: "작별하지 않는다", author: "한강", why: "기억/상실의 서사"),
                    BookSeed(id: "han-wind", title: "바람이 분다, 가라", author: "한강", why: "미스터리한 서사로 확장")
                ]),
                RoadmapStep(id: "han-3", title: "Step 3 · 심화", purpose: "초기작/에세이로 작품군 전체 조망", books: [
                    BookSeed(id: "han-black", title: "검은 사슴", author: "한강", why: "초기 장편으로 세계관 확장"),
                    BookSeed(id: "han-now", title: "노랑무늬영원", author: "한강", why: "초기 강렬한 이미지"),
                    BookSeed(id: "han-ess", title: "한강 에세이", author: "한강", why: "문장 뒤의 생각을 확인")
                ])
            ]
        ),
        
        // 18 Kim Young-ha
        RoadmapAuthor(
            id: "kimyoungha",
            name: "김영하",
            nationality: "대한민국",
            era: "현대",
            tagline: "속도감 있는 문장으로 욕망과 현대성을 탐구",
            steps: [
                RoadmapStep(id: "kyh-1", title: "Step 1 · 입문", purpose: "가볍고 빠르게 김영하의 리듬을", books: [
                    BookSeed(id: "kyh-quiz", title: "퀴즈쇼", author: "김영하", why: "대중적 서사로 입문"),
                    BookSeed(id: "kyh-emp", title: "살인자의 기억법", author: "김영하", why: "짧고 강한 긴장"),
                    BookSeed(id: "kyh-stories", title: "오직 두 사람", author: "김영하", why: "단편으로 관계와 감정")
                ]),
                RoadmapStep(id: "kyh-2", title: "Step 2 · 핵심", purpose: "정체성과 현대성의 핵심작", books: [
                    BookSeed(id: "kyh-world", title: "세계의 끝 여자친구", author: "김영하", why: "젊은 감각과 서사 실험"),
                    BookSeed(id: "kyh-dark", title: "너의 목소리가 들려", author: "김영하", why: "현대적 불안"),
                    BookSeed(id: "kyh-roman", title: "검은 꽃", author: "김영하", why: "역사적 서사 확장")
                ]),
                RoadmapStep(id: "kyh-3", title: "Step 3 · 심화", purpose: "에세이로 '왜 쓰는가'까지", books: [
                    BookSeed(id: "kyh-travel", title: "여행의 이유", author: "김영하", why: "사유하는 에세이"),
                    BookSeed(id: "kyh-read", title: "읽다", author: "김영하", why: "독서/글쓰기 관점"),
                    BookSeed(id: "kyh-more", title: "김영하 에세이", author: "김영하", why: "작가의 목소리 정리")
                ])
            ]
        ),
        
        // 19 Park Wansuh
        RoadmapAuthor(
            id: "parkwansuh",
            name: "박완서",
            nationality: "대한민국",
            era: "현대",
            tagline: "전후 한국 사회의 감정과 가족사를 날카롭게 기록",
            steps: [
                RoadmapStep(id: "pws-1", title: "Step 1 · 입문", purpose: "단편/중편으로 문체에 익숙해지기", books: [
                    BookSeed(id: "pws-stories", title: "박완서 단편집", author: "박완서", why: "일상 속 비극과 유머"),
                    BookSeed(id: "pws-mother", title: "엄마의 말뚝", author: "박완서", why: "가족사와 시대"),
                    BookSeed(id: "pws-naked", title: "나목", author: "박완서", why: "전후의 상처를 서사로")
                ]),
                RoadmapStep(id: "pws-2", title: "Step 2 · 핵심", purpose: "대표 장편으로 시대 감각을 확장", books: [
                    BookSeed(id: "pws-rose", title: "그 많던 싱아는 누가 다 먹었을까", author: "박완서", why: "자전적 성장과 시대"),
                    BookSeed(id: "pws-ongoing", title: "미망", author: "박완서", why: "근현대사의 흐름"),
                    BookSeed(id: "pws-who", title: "그대 아직도 꿈꾸고 있는가", author: "박완서", why: "여성/가족/사회")
                ]),
                RoadmapStep(id: "pws-3", title: "Step 3 · 심화", purpose: "에세이로 현실 감각을 보강", books: [
                    BookSeed(id: "pws-essay", title: "박완서 에세이", author: "박완서", why: "생활 감각과 문장"),
                    BookSeed(id: "pws-more", title: "다만 여행자가 될 수 있다면", author: "박완서", why: "삶의 시선"),
                    BookSeed(id: "pws-re", title: "박완서 산문", author: "박완서", why: "서사 밖에서 다시 읽기")
                ])
            ]
        ),
        
        // 20 Jo Jung-rae
        RoadmapAuthor(
            id: "jojungrae",
            name: "조정래",
            nationality: "대한민국",
            era: "현대",
            tagline: "한국 현대사의 거대한 파고와 동시대 문제를 장편 서사로 구현",
            steps: [
                RoadmapStep(
                    id: "jjr-1",
                    title: "Step 1 · 입문",
                    purpose: "대하소설에 들어가기 전, 비교적 접근 쉬운 장편으로 문체 적응",
                    books: [
                        BookSeed(id: "jjr-human", title: "인간 연습", author: "조정래", why: "분단 이후 개인의 시선으로 시대 문제를 좁혀 읽기"),
                        BookSeed(id: "jjr-scare", title: "허수아비춤", author: "조정래", why: "자본/권력/경제 현실을 소설로 해부"),
                        BookSeed(id: "jjr-flower1", title: "풀꽃도 꽃이다 1", author: "조정래", why: "교육·경쟁 사회의 구조를 입체적으로"),
                    ]
                ),
                RoadmapStep(
                    id: "jjr-2",
                    title: "Step 2 · 핵심",
                    purpose: "동시대/현대사를 큰 호흡으로 읽는 감각 만들기",
                    books: [
                        BookSeed(id: "jjr-jungle1", title: "정글만리 1", author: "조정래", why: "글로벌 자본주의/중국을 배경으로 한 현실 소설"),
                        BookSeed(id: "jjr-taebaek1", title: "태백산맥 1", author: "조정래", why: "해방~한국전쟁 전후의 민중사를 본격적으로"),
                        BookSeed(id: "jjr-hangang1", title: "한강 1", author: "조정래", why: "산업화 시대의 격변을 인물군으로 따라가기"),
                    ]
                ),
                RoadmapStep(
                    id: "jjr-3",
                    title: "Step 3 · 심화",
                    purpose: "대하 3부작을 '완독' 모드로: 역사 인식과 서사 체력 완성",
                    books: [
                        BookSeed(id: "jjr-arirang", title: "아리랑 (전12권)", author: "조정래", why: "식민지~해방 전후의 민족사를 총체적으로"),
                        BookSeed(id: "jjr-taebaek", title: "태백산맥 (전10권)", author: "조정래", why: "이념/폭력/기억을 가장 밀도 있게"),
                        BookSeed(id: "jjr-hangang", title: "한강 (전10권)", author: "조정래", why: "근현대사 3부작의 마지막 축으로 연결"),
                    ]
                )
            ]
        )
    ]
}
