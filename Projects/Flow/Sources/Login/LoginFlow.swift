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
        self.rootViewController = LoginViewController(viewModel: container.resolve(LoginViewModel.self)!)
//        self.rootViewController = container.resolve(LoginViewController.self)!
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .loginIsRequired:
                return navigateToLogin()
            case .tabIsRequired:
                return .end(forwardToParentFlowWithStep: PiCKStep.tabIsRequired)
            case .testIsRequired:
                return .end(forwardToParentFlowWithStep: PiCKStep.testIsRequired)
            default:
                return .none
        }
    }

    private func navigateToLogin() -> FlowContributors {
//        let vc = container.resolve(LoginViewController.self)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

}
