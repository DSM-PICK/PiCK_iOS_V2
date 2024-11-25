import UIKit

import RxFlow
import Swinject

import Core

public class AppFlow: Flow {
    private var window: UIWindow
    private let container: Container
    private let rawValue = UserDefaultStorage.shared.get(forKey: .displayMode) as? Int

    public var root: RxFlow.Presentable {
        window.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: rawValue ?? 0) ?? .unspecified
        return window
    }

    public init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else {
            return .none
        }

        switch step {
        case .onboardingIsRequired:
            return presentOnboardingView()
        case .loginIsRequired:
            return presentLoginView()
        case .tabIsRequired:
            return presentTabView()
        default:
            return .none
        }
    }

    private func presentOnboardingView() -> FlowContributors {
        let onboardingFlow = OnboardingFlow(container: self.container)

        Flows.use(onboardingFlow, when: .created) { [weak self] root in
            self?.window.rootViewController = root
        }

        return .one(
            flowContributor: .contribute(
                withNextPresentable: onboardingFlow,
                withNextStepper: OneStepper(
                    withSingleStep: PiCKStep.onboardingIsRequired
                )
            )
        )
    }

    private func presentLoginView() -> FlowContributors {
        let loginFlow = LoginFlow(container: self.container)

        Flows.use(loginFlow, when: .created) { [weak self] root in
            UIView.transition(
                with: self!.window,
                duration: 0.5,
                options: .transitionCrossDissolve
            ) {
                self?.window.rootViewController = root
            }
        }

        return .one(
            flowContributor: .contribute(
                withNextPresentable: loginFlow,
                withNextStepper: OneStepper(
                    withSingleStep: PiCKStep.loginIsRequired
                )
            )
        )
    }

    private func presentTabView() -> FlowContributors {
        let tabsFlow = TabsFlow(container: self.container)

        Flows.use(tabsFlow, when: .created) { [weak self] root in
            UIView.transition(
                with: self!.window,
                duration: 0.5,
                options: .transitionCrossDissolve
            ) {
                self?.window.rootViewController = root
            }
        }

        return .one(
            flowContributor: .contribute(
                withNextPresentable: tabsFlow,
                withNextStepper: OneStepper(
                    withSingleStep: PiCKStep.tabIsRequired
                )
            )
        )
    }

}
