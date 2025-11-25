import UIKit
import UserNotifications

import Swinject

import Firebase
import FirebaseMessaging

import Core
import Data
import Presentation

#if targetEnvironment(macCatalyst)
import AppKit
#endif

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    static var container = Container()
    var assembler: Assembler!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
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

        // Mac Catalyst에서 MenuBarApp 실행
        #if targetEnvironment(macCatalyst)
        launchMenuBarApp()
        #endif

        return true
    }

    #if targetEnvironment(macCatalyst)
    private func launchMenuBarApp() {
        let menuBarAppBundleID = "com.pick.PiCKMenuBar"

        // 이미 실행 중인지 확인
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains { $0.bundleIdentifier == menuBarAppBundleID }

        if !isRunning {
            // 번들 ID로 앱 실행 시도
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.activates = false // 백그라운드에서 실행

            NSWorkspace.shared.openApplication(
                at: URL(fileURLWithPath: "/Applications/MenuBarApp.app"),
                configuration: configuration
            ) { app, error in
                if let error = error {
                    print("MenuBarApp 실행 실패: \(error.localizedDescription)")
                    // 다른 경로에서 시도
                    self.tryLaunchMenuBarAppFromBundle()
                } else {
                    print("MenuBarApp 실행 성공")
                }
            }
        }
    }

    private func tryLaunchMenuBarAppFromBundle() {
        // 메인 앱 번들 내부에서 MenuBarApp 찾기
        guard let bundlePath = Bundle.main.bundlePath as NSString? else { return }
        let menuBarAppPath = bundlePath.appendingPathComponent("Contents/Resources/MenuBarApp.app")

        if FileManager.default.fileExists(atPath: menuBarAppPath) {
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.activates = false

            NSWorkspace.shared.openApplication(
                at: URL(fileURLWithPath: menuBarAppPath),
                configuration: configuration
            ) { app, error in
                if let error = error {
                    print("번들 내 MenuBarApp 실행 실패: \(error.localizedDescription)")
                } else {
                    print("번들 내 MenuBarApp 실행 성공")
                }
            }
        }
    }
    #endif

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
