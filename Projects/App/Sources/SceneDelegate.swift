import UIKit

import RxFlow

import Core
import Flow

import Siren

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
        
        SirenConfiguration.setup()
        SirenConfiguration.check()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AnalyticsConfiguration.requestTrackingAuthorization()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        // 설정 앱에서 추적 권한을 바꾸고 돌아온 경우를 바로 반영
        AnalyticsConfiguration.applyCurrentTrackingStatus()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {}

}
