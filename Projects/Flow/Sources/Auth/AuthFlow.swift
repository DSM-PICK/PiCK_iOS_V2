import UIKit
import RxFlow
import Swinject

import Core
import Presentation

public class AuthFlow: Flow {
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
        case .signinIsRequired:
            return navigateToSignin()
        case .changePasswordIsRequired:
            return navigateToPasswordChange()
        case let .newPasswordIsRequired(accountId, code):
            return navigateToNewPassword(accountId: accountId, code: code)
        case .tabIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.tabIsRequired)
        case .testIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.testIsRequired)
        case .logoutIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.onboardingIsRequired)
        case .verifyEmailIsRequired:
            return navigateToVerifyEmail()
        case let .passwordSettingIsRequired(email, verificationCode):
            return navigateToPasswordSetting(email: email, verificationCode: verificationCode)
        case let .infoSettingIsRequired(email, password, verificationCode):
            return navigateToInfoSetting(email: email, password: password, verificationCode: verificationCode)
        case .signupComplete:
            return .end(forwardToParentFlowWithStep: PiCKStep.tabIsRequired)
        default:
            return .none
        }
    }

    private func navigateToSignin() -> FlowContributors {
        let vc = SigninViewController(reactor: container.resolve(SigninReactor.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.reactor
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

    private func navigateToNewPassword(accountId: String, code: String) -> FlowContributors {
        let vc = NewPasswordViewController(viewModel: container.resolve(NewPasswordViewModel.self)!)

        vc.accountId = accountId
        vc.code = code

        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToInfoSetting(email: String, password: String, verificationCode: String) -> FlowContributors {
        let infoVM = container.resolve(InfoSettingViewModel.self)!
        let infoVC = InfoSettingViewController(viewModel: infoVM)

        infoVC.email = email
        infoVC.password = password
        infoVC.verificationCode = verificationCode

        self.rootViewController.pushViewController(infoVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: infoVC,
            withNextStepper: infoVC.viewModel
        ))
    }

    private func navigateToVerifyEmail() -> FlowContributors {
        let reactor = container.resolve(VerifyEmailReactor.self)!
        let vc = VerifyEmailViewController(reactor: reactor)

        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.reactor
        ))
    }

    private func navigateToPasswordSetting(email: String, verificationCode: String) -> FlowContributors {
        let vm = container.resolve(PasswordSettingViewModel.self)!
        let vc = PasswordSettingViewController(viewModel: vm)

        vc.email = email
        vc.verificationCode = verificationCode

        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }
}
