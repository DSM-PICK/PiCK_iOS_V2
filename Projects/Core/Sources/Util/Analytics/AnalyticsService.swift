import Foundation

import FirebaseAnalytics

public struct AnalyticsService {
    // Firebase 는 setAnalyticsCollectionEnabled 값을 앱 재실행 후에도 유지하므로,
    // 이번 실행에서 현재 권한을 적용하기 전까지는 항상 꺼진 것으로 취급함
    private static var isCollectionEnabled = false
    // 수집이 꺼져 있는 동안 표시된 화면을, 수집을 켤 때 한 번 기록하기 위해 보관
    private static var currentScreen: (name: String, screenClass: String)?
}

// 모든 메서드는 메인 스레드에서 호출해야 함
public extension AnalyticsService {
    // PROD 구성이면서 사용자가 추적을 허용했을 때만 수집을 켬
    static func setCollectionEnabled(isTrackingAuthorized: Bool) {
        let isEnabled = AppEnvironment.isProd && isTrackingAuthorized
        let wasEnabled = isCollectionEnabled

        isCollectionEnabled = isEnabled
        Analytics.setAnalyticsCollectionEnabled(isEnabled)

        if isEnabled && !wasEnabled, let currentScreen {
            sendScreenView(screenName: currentScreen.name, screenClass: currentScreen.screenClass)
        }
    }

    static func logScreenView(screenName: String, screenClass: String) {
        currentScreen = (screenName, screenClass)
        guard isCollectionEnabled else { return }
        sendScreenView(screenName: screenName, screenClass: screenClass)
    }

    static func log(_ event: AnalyticsEvent) {
        guard isCollectionEnabled else { return }
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}

private extension AnalyticsService {
    static func sendScreenView(screenName: String, screenClass: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass
        ])
    }
}
