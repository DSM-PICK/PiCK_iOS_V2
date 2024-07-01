import UIKit

import RxFlow
import Swinject

import Core
import Presentation

public class OnboardingFlow: Flow {
    public let container: Container
    private let rootViewController = BaseNavigationController()
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
    }
    
    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .onboardingIsRequired:
                return navigateToOnboarding()
            case .loginIsRequired:
                return navigateToLogin()
            default:
                return .none
        }
    }
    
    private func navigateToOnboarding() -> FlowContributors {
        let viewModel = container.resolve(OnboardingViewModel.self)!
        let onboardingViewController = OnboardingViewController(
            viewModel: viewModel
        )
        self.rootViewController.pushViewController(onboardingViewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: onboardingViewController,
            withNextStepper: onboardingViewController.viewModel
        ))
    }

    private func navigateToLogin() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: PiCKStep.loginIsRequired)
    }

}
