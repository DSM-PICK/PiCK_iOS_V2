import UIKit

import RxFlow
import Swinject

import Core
import Presentation

public class HomeFlow: Flow {
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
        case .homeIsRequired:
            return navigateToHome()
        case .alertIsRequired:
            return navigateToAlert()
        case .noticeIsRequired:
            return navigateToNotice()
        case .noticeDetailIsRequired(let id):
            return navigateToNoticeDetail(id: id)
        default:
            return .none
        }
    }

    private func navigateToHome() -> FlowContributors {
        let vc = container.resolve(HomeViewController.self)!

        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToAlert() -> FlowContributors {
        let alertFlow = AlertFlow(container: self.container)

        Flows.use(alertFlow, when: .created) { root in
            root.hidesBottomBarWhenPushed = true
            self.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: alertFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.alertIsRequired)
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

    private func navigateToNoticeDetail(id: UUID) -> FlowContributors {
        let vc = container.resolve(NoticeDetailViewController.self)!
        vc.id = id

        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .none
    }

}
