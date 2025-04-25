import UIKit
import AppTrackingTransparency

import RxFlow

import FirebaseAnalytics

import Flow

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator = FlowCoordinator()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let appFlow = AppFlow(window: window!, container: AppDelegate.container)
        self.coordinator.coordinate(
            flow: appFlow,
            with: AppStepper(),
            allowStepWhenDismissed: false
        )
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    Analytics.setAnalyticsCollectionEnabled(true)
                case .denied, .restricted, .notDetermined:
                    Analytics.setAnalyticsCollectionEnabled(false)
                @unknown default:
                    fatalError("ATTrakingManager status unknown")
                }
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}
