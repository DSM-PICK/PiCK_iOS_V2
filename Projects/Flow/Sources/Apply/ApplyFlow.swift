import UIKit

import RxFlow
import Swinject

import Core
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
        case .outingApplyIsRequired:
            return navigateToOutingApply()
        case .earlyLeaveApplyIsRequired:
            return navigateToEarlyLeaveApply()
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

//    private func navigateToOutingApply() -> FlowContributors {
//        let noticeFlow = OutingApplyFlow(container: self.container)
//        Flows.use(noticeFlow, when: .created) { [weak self] root in
//            root.hidesBottomBarWhenPushed = true
//            self?.rootViewController.pushViewController(root, animated: true)
//        }
//        return .one(flowContributor: .contribute(
//            withNextPresentable: noticeFlow,
//            withNextStepper: OneStepper(withSingleStep: PiCKStep.outingApplyIsRequired)
//        ))
//    }
//
//    private func navigateToOutingApply() -> FlowContributors {
//        let noticeFlow = OutingApplyFlow(container: self.container)
//        Flows.use(noticeFlow, when: .created) { [weak self] root in
//            root.hidesBottomBarWhenPushed = true
//            self?.rootViewController.pushViewController(root, animated: true)
//        }
//        return .one(flowContributor: .contribute(
//            withNextPresentable: noticeFlow,
//            withNextStepper: OneStepper(withSingleStep: PiCKStep.outingApplyIsRequired)
//        ))
//    }

    private func navigateToOutingApply() -> FlowContributors {
        let outingApplyFlow = OutingApplyFlow(container: self.container)
        Flows.use(outingApplyFlow, when: .created) { [weak self] root in
            root.hidesBottomBarWhenPushed = true
            self?.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: outingApplyFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.outingApplyIsRequired)
        ))
    }

    private func navigateToEarlyLeaveApply() -> FlowContributors {
        let earlyLeaveApplyFlow = EarlyLeaveApplyFlow(container: self.container)
        Flows.use(earlyLeaveApplyFlow, when: .created) { [weak self] root in
            root.hidesBottomBarWhenPushed = true
            self?.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: earlyLeaveApplyFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.earlyLeaveApplyIsRequired)
        ))
    }

}
