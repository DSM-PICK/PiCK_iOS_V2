import UIKit
import RxFlow
import Swinject

import Core
import Presentation

public class LoginFlow: Flow {
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
        case .loginIsRequired:
            return navigateToLogin()
        case .signUpIsRequired:
            return navigateToSignUp()
        case .changePasswordIsRequired:
            return navigateToPasswordChange()
        case .newPasswordIsRequired:
            return .none
        // SignUp Step
        case .verifyEmailIsRequired:
            return navigateToVerifyEmail()
        case .passwordSettingIsRequired:
            return navigateToPasswordSetting()
        case .infoSettingIsRequired:
            return navigateToInfoSetting()
        case .tabIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.tabIsRequired)
        case .testIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.testIsRequired)
        case .logoutIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.onboardingIsRequired)
        default:
            return .none
        }
    }

    private func navigateToLogin() -> FlowContributors {
        let vc = LoginViewController(reactor: container.resolve(SigninReactor.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.reactor
        ))
    }

    private func navigateToSignUp() -> FlowContributors {
        let vc = VerifyEmailViewController(viewModel: container.resolve(VerifyEmailViewModel.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToPasswordChange() -> FlowContributors {
        let vc = ChangePasswordViewController(viewModel: container.resolve(ChangePasswordViewModel.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
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

    private func navigateToInfoSetting() -> FlowContributors {
        let vc = InfoSettingViewController(viewModel: container.resolve(InfoSettingViewModel.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }
}
