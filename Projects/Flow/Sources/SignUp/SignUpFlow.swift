import UIKit
import RxFlow
import Swinject
import Core
import Presentation

public class SignUpFlow: Flow {
    public let container: Container
    private var rootViewController = BaseNavigationController()

    private var signUpData = SignUpData()

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
            if let verifyVC = rootViewController.topViewController as? VerifyEmailViewController {
                let data = verifyVC.getCurrentEmailData()
                signUpData.email = data.email
                signUpData.verificationCode = data.verificationCode
                
                print("수집된 데이터:")
                print("Email: \(signUpData.email)")
                print("VerificationCode: \(signUpData.verificationCode)")
            }
            return navigateToPasswordSetting()
        case .infoSettingIsRequired(let email, let password, let verificationCode):
            // 데이터 저장
            signUpData.email = email
            signUpData.password = password
            signUpData.verificationCode = verificationCode
            return navigateToInfoSetting()
        case .signUpComplete:
            return .end(forwardToParentFlowWithStep: PiCKStep.tabIsRequired)
        case .tabIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.tabIsRequired)
        case .loginIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.loginIsRequired)
        default:
            return .none
        }
    }

    private func navigateToInfoSetting() -> FlowContributors {
        let infoVM = container.resolve(InfoSettingViewModel.self)!
        let infoVC = InfoSettingViewController(viewModel: infoVM)
        
        // 저장된 데이터 전달
        infoVC.email = signUpData.email
        infoVC.password = signUpData.password
        infoVC.verificationCode = signUpData.verificationCode
        
        print("InfoSetting으로 전달되는 데이터:")
        print("Email: \(signUpData.email)")
        print("Password: \(signUpData.password)")
        print("VerificationCode: \(signUpData.verificationCode)")
        
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

    private func navigateToPasswordSetting() -> FlowContributors {
        let vm = container.resolve(PasswordSettingViewModel.self)!
        let vc = PasswordSettingViewController(viewModel: vm)
        
        // 저장된 데이터를 ViewController에 설정
        vc.email = signUpData.email
        vc.verificationCode = signUpData.verificationCode
        
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }
    
}

private struct SignUpData {
    var email: String = ""
    var password: String = ""
    var verificationCode: String = ""
}
