import UIKit
import RxFlow
import Swinject
import Core
import Presentation

public class SignUpFlow: Flow {
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
        case .verifyEmailIsRequired:
            return navigateToVerifyEmail()
        case .passwordSettingIsRequired:
            return navigateToPasswordSetting()
        case .tabIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.tabIsRequired)
        case .loginIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.loginIsRequired)
        default:
            return .none
        }
    }

    private func navigateToVerifyEmail() -> FlowContributors {
        let vc = VerifyEmailViewController(viewModel: container.resolve(VerifyEmailViewModel.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToPasswordSetting() -> FlowContributors {
        let vc = PasswordSettingViewController(viewModel: container.resolve(PasswordSettingViewModel.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }
}
