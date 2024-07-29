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
                return navigateToLogin()
            case .tabIsRequired:
                return .end(forwardToParentFlowWithStep: PiCKStep.tabIsRequired)
            default:
                return .none
        }
    }
    
    private func navigateToOnboarding() -> FlowContributors {
        let viewModel = container.resolve(OnboardingViewModel.self)!
        let vc = OnboardingViewController(
            viewModel: viewModel
        )
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToLogin() -> FlowContributors {
        let loginFlow = LoginFlow(container: self.container)
        
        Flows.use(loginFlow, when: .created) { root in
            self.rootViewController.pushViewController(root, animated: true)
            root.navigationItem.hidesBackButton = true
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: loginFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.loginIsRequired)
        ))
    }

}
