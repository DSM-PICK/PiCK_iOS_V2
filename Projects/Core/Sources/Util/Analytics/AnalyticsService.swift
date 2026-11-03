import Foundation

import FirebaseAnalytics

public struct AnalyticsService {}

public extension AnalyticsService {
    // PROD 구성이면서 사용자가 추적을 허용했을 때만 수집을 켬
    static func setCollectionEnabled(isTrackingAuthorized: Bool) {
        Analytics.setAnalyticsCollectionEnabled(AppEnvironment.isProd && isTrackingAuthorized)
    }

    static func logScreenView(screenName: String, screenClass: String) {
        guard AppEnvironment.isProd else { return }
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass
        ])
    }

    static func log(_ event: AnalyticsEvent) {
        guard AppEnvironment.isProd else { return }
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}
