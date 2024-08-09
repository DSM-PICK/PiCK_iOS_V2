import UIKit

import RxFlow
import Swinject

import Core
import Presentation

public class NoticeFlow: Flow {
    public let container: Container
    private let rootViewController: NoticeListViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(NoticeListViewController.self)!
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
        case .noticeIsRequired:
            return navigateToNotice()
        case .noitceDetailIsRequired:
            return navigateToNoticeDetail()
        default:
            return .none
        }
    }

    private func navigateToNotice() -> FlowContributors {
        let vc = container.resolve(NoticeListViewController.self)!
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToNoticeDetail() -> FlowContributors {
        let vc = container.resolve(NoticeDetailViewController.self)!
        self.rootViewController.navigationController?.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }
    
}
