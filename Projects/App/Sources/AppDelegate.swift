import UIKit
import UserNotifications
import WatchConnectivity

import Swinject

import Firebase

import Core
import Data
import Presentation

@main
final class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    static var container = Container()
    var assembler: Assembler!

    private var keychain: (any Keychain)?
    private var session: WCSession!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.session = .default
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }

        assembler = Assembler([
            KeychainAssembly(),
            DataSourceAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            PresentationAssembly()
         ], container: AppDelegate.container)

        // Firebase 설정
        FirebaseApp.configure()

        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
        application.registerForRemoteNotifications()

        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self

        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}

// MARK: WCSession
extension AppDelegate {
    public func sessionDidBecomeInactive(_ session: WCSession) { }
    public func sessionDidDeactivate(_ session: WCSession) { }

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        guard activationState == .activated else {
            print("❌WCSession 활성화되지 않음")
            return
        }
        print("✅WCSession 활성화 완료")

        guard let keychain else {
            print("❌Keychain 로드 실패")
            return
        }
        print("Keychain 데이터 : \(keychain.load(type: .accessToken))")
        print("✅Keychain 로드 완료")

        let message: [String: Any] = [
            "access_oken": keychain.load(type: .accessToken)
        ]

        session.sendMessage(message) { _ in } errorHandler: { error in
            print("❌WCSession 메시지 전송 실패: \(error.localizedDescription)")
        }

    }

    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        guard let keychain else {
            print("❌keychain 로드 실패")
            return
        }
        print("✅Apple Watch에서 메시지 수신 성공: \(message)")

        let response: [String: Any] = ["accessToken": keychain.load(type: .accessToken)]
        replyHandler(response)
    }
}

// MARK: Firebase
extension AppDelegate: UNUserNotificationCenterDelegate {
    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("APNS token: \(deviceToken.base64EncodedString())")
        Messaging.messaging().apnsToken = deviceToken
    }

    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.list, .banner])
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        let token = String(describing: fcmToken)

        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
          }
        }

        let dataDict: [String: String] = ["token": token]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}
