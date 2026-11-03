import Foundation

public struct AppEnvironment {}

public extension AppEnvironment {
    // Info.plist 의 APP_CONFIGURATION 에는 빌드 구성 이름($(CONFIGURATION))이 들어감 (STAGE / PROD)
    static let configuration: String = Bundle.main.object(
        forInfoDictionaryKey: "APP_CONFIGURATION"
    ) as? String ?? ""

    static var isProd: Bool {
        return configuration == "PROD"
    }

    // xcconfig 에 SENTRY_DSN 이 없거나 잘못 들어가 있으면 nil 을 반환해 Sentry 초기화를 건너뜀
    static let sentryDSN: String? = {
        guard let dsn = Bundle.main.object(
            forInfoDictionaryKey: "SENTRY_DSN"
        ) as? String,
              let url = URL(string: dsn),
              url.scheme == "https",
              url.host != nil
        else { return nil }
        return dsn
    }()

    static let bundleID: String = Bundle.main.bundleIdentifier ?? ""

    static let appVersion: String = Bundle.main.object(
        forInfoDictionaryKey: "CFBundleShortVersionString"
    ) as? String ?? ""

    static let buildNumber: String = Bundle.main.object(
        forInfoDictionaryKey: "CFBundleVersion"
    ) as? String ?? ""
}
