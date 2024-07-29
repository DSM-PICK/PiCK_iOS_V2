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
        let selfStudyFlow = SelfStudyFlow(container: self.container)
        
        Flows.use(selfStudyFlow, when: .created) { root in
            root.hidesBottomBarWhenPushed = true
            self.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: selfStudyFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.selfStudyIsRequired)
        ))
    }

    private func navigateToBugReport() -> FlowContributors {
        let bugReportFlow = BugReportFlow(container: self.container)
        
        Flows.use(bugReportFlow, when: .created) { root in
            root.hidesBottomBarWhenPushed = true
            self.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: bugReportFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.bugReportIsRequired)
        ))
    }

    private func navigateToMyPage() -> FlowContributors {
        let myPageFlow = MyPageFlow(container: self.container)
        
        Flows.use(myPageFlow, when: .created) { root in
            root.hidesBottomBarWhenPushed = true
            self.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: myPageFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.myPageIsRequired)
        ))
    }

//        private func navigateToLogout() -> FlowContributors {
//            let viewModel = AllTabViewModel()
//            let vc = AllTabViewController(
//                viewModel: viewModel
//            )
//            self.rootViewController.pushViewController(vc, animated: true)
//            return .one(flowContributor: .contribute(
//                withNextPresentable: vc,
//                withNextStepper: vc.viewModel
//            ))
//        }

}
