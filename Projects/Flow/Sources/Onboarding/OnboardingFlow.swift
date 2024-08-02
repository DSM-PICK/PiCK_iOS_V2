import UIKit

import RxFlow
import Swinject

import Core
import Presentation

public class OnboardingFlow: Flow {
    public let container: Container
    private var rootViewController = BaseNavigationController()
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
            return .end(forwardToParentFlowWithStep: PiCKStep.loginIsRequired)
        case .tabIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.tabIsRequired)
        case .testIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.testIsRequired)
        default:
            return .none
        }
    }
    
    private func navigateToOnboarding() -> FlowContributors {
        let vc = OnboardingViewController(viewModel: container.resolve(OnboardingViewModel.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }
    
}
