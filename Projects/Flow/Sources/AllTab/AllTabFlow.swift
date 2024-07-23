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
            return navigateToBug()
        case .myPageIsRequired:
            return navigateToAllMyPage()
        default:
            return .none
        }
    }

    private func navigateToAllTab() -> FlowContributors {
        let viewModel = AllTabViewModel()
        let vc = AllTabViewController(
            viewModel: viewModel
        )
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
        let viewModel = AllTabViewModel()
        let vc = AllTabViewController(
            viewModel: viewModel
        )
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToBug() -> FlowContributors {
        let viewModel = BugReportViewModel()
        let vc = BugReportViewController(
            viewModel: viewModel
        )
        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToAllMyPage() -> FlowContributors {
        let viewModel = MyPageViewModel()
        let vc = MyPageViewController(
            viewModel: viewModel
        )
        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
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
