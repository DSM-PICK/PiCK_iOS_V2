import UIKit
import RxFlow
import Swinject
import Core
import Presentation

public class PasswordChangeFlow: Flow {
    public let container: Container
    private var rootViewController = BaseNavigationController()

    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else {
            return .none
        }

        switch step {
        case .changePasswordIsRequired:
            return navigateToChangePassword()
        case .newPasswordIsRequired:
            return navigateToNewPassword()
        case .loginIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.loginIsRequired)
        case .dismissNewPassword:
            rootViewController.popViewController(animated: true)
            return .none
        default:
            return .none
        }
    }

    private func navigateToChangePassword() -> FlowContributors {
        let vc = ChangePasswordViewController(viewModel: container.resolve(ChangePasswordViewModel.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToNewPassword() -> FlowContributors {
        let vc = NewPasswordViewController(viewModel: container.resolve(NewPasswordViewModel.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }
}
