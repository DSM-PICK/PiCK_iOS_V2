import Foundation
import AppTrackingTransparency

import Core

public class AnalyticsConfiguration {
    // 저장된 수집 상태 대신 현재 ATT 권한을 즉시 적용 (앱 시작, 포그라운드 복귀 시 호출)
    public static func applyCurrentTrackingStatus() {
        AnalyticsService.setCollectionEnabled(
            isTrackingAuthorized: ATTrackingManager.trackingAuthorizationStatus == .authorized
        )
    }

    // 권한을 아직 묻지 않았다면 팝업을 띄우고, 응답을 수집 상태에 반영
    public static func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            // 콜백은 메인 스레드가 아닐 수 있음
            DispatchQueue.main.async {
                AnalyticsService.setCollectionEnabled(isTrackingAuthorized: status == .authorized)
            }
        }
    }
}
