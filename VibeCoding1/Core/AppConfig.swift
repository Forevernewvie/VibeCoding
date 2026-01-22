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
}
