import UIKit

import RxFlow
import Swinject

import Core
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
        case .myPageIsRequired:
            return navigateToMyPage()
        case .tabIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.appIsRequired)
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

        Flows.use(noticeFlow, when: .created) { [weak self] root in
            root.hidesBottomBarWhenPushed = true
            self?.rootViewController.pushViewController(root, animated: true)
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

    private func navigateToMyPage() -> FlowContributors {
        let vc = container.resolve(MyPageViewController.self)!

        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

}
