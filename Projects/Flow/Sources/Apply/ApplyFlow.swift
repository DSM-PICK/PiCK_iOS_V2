import UIKit

import RxFlow
import Swinject

import Core
import DesignSystem
import Presentation

public class ApplyFlow: Flow {
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
        case .applyIsRequired:
            return navigateToApply()
        case .weekendMealApplyIsRequired:
            return navigateToWeekendMealApply()
        case .classroomMoveApplyIsRequired:
            return navigateToClassroomMoveApply()
        case .outingApplyIsRequired:
            return navigateToOutingApply()
        case .earlyLeaveApplyIsRequired:
            return navigateToEarlyLeaveApply()
        case let .applyAlertIsRequired(successType, alertType):
            return presentApplyAlert(successType: successType, alertType: alertType)
        case .tabIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.popIsRequired)
        default:
            return .none
        }
    }

    private func navigateToApply() -> FlowContributors {
        let vc = container.resolve(ApplyViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToWeekendMealApply() -> FlowContributors {
        let vc = container.resolve(WeekendMealApplyViewController.self)!

        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToClassroomMoveApply() -> FlowContributors {
        let vc = container.resolve(ClassroomMoveApplyViewController.self)!

        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToOutingApply() -> FlowContributors {
        let vc = container.resolve(OutingApplyViewController.self)!

        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToEarlyLeaveApply() -> FlowContributors {
        let vc = container.resolve(EarlyLeaveApplyViewController.self)!

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

        self.rootViewController.tabBarController?.selectedIndex = 0
        self.rootViewController.popToRootViewController(animated: true)
        self.rootViewController.present(alert, animated: true)
        return .none
    }

}
