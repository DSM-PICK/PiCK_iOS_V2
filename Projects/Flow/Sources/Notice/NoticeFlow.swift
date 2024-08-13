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
        self.rootViewController = NoticeListViewController(viewModel: container.resolve(NoticeListViewModel.self)!)
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
        case .noticeIsRequired:
            return navigateToNotice()
        case let .noitceDetailIsRequired(id):
            return navigateToNoticeDetail(id: id)
        default:
            return .none
        }
    }

    private func navigateToNotice() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    private func navigateToNoticeDetail(id: UUID) -> FlowContributors {
        let vc = container.resolve(NoticeDetailViewController.self)!
        vc.id = id

        self.rootViewController.navigationController?.pushViewController(vc, animated: true)
        return .none
    }
    
}
