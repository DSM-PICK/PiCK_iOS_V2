import UIKit

import RxFlow
import Swinject

import Core
import Presentation

public class LoginFlow: Flow {
    public let container: Container
    private let rootViewController: LoginViewController
    public var root: Presentable {
        return rootViewController
    }
    
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(LoginViewController.self)!
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .loginIsRequired:
                return navigateToLogin()
            case .mainIsRequired:
                return navigateToMain()
            default:
                return .none
        }
    }
    
    private func navigateToLogin() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
    
    private func navigateToMain() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: PiCKStep.mainIsRequired)
    }

}
