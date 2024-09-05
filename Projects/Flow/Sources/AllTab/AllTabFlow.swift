import UIKit

import RxFlow
import Swinject

import Core
import DesignSystem
import Presentation

public class AllTabFlow: Flow {
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
        case .allTabIsRequired:
            return navigateToAllTab()
        case .noticeIsRequired:
            return navigateToNotice()
        case .selfStudyIsRequired:
            return navigateToSelfStudy()
        case .bugReportIsRequired:
            return navigateToBugReport()
        case .customIsRequired:
            return navigateToCustom()
        case .notificationSettingIsRequired:
            return navigateToNotificationSetting()
        case .myPageIsRequired:
            return navigateToMyPage()
        case .tabIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.appIsRequired)
        case let .applyAlertIsRequired(successType, alertType):
            return presentApplyAlert(successType: successType, alertType: alertType)
        default:
            return .none
        }
    }

    private func navigateToAllTab() -> FlowContributors {
        let vc = container.resolve(AllTabViewController.self)!

        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToNotice() -> FlowContributors {
        let noticeFlow = NoticeFlow(container: self.container)

        Flows.use(noticeFlow, when: .created) { root in
            root.hidesBottomBarWhenPushed = true
            self.rootViewController.pushViewController(root, animated: true)
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: noticeFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.noticeIsRequired)
        ))
    }

    private func navigateToSelfStudy() -> FlowContributors {
        let vc = container.resolve(SelfStudyViewController.self)!

        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToBugReport() -> FlowContributors {
        let vc = container.resolve(BugReportViewController.self)!

        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToCustom() -> FlowContributors {
        let vc = container.resolve(CustomSettingViewController.self)!

        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToNotificationSetting() -> FlowContributors {
        let vc = container.resolve(NotificationViewController.self)!

        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToMyPage() -> FlowContributors {
        let vc = container.resolve(MyPageViewController.self)!

        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func presentApplyAlert(successType: SuccessType, alertType: DisappearAlertType) -> FlowContributors {
        let alert = PiCKDisappearAlert(
            successType: successType,
            alertType: alertType
        )
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        self.rootViewController.popToRootViewController(animated: true)
        self.rootViewController.present(alert, animated: true)
        return .none
    }

}
