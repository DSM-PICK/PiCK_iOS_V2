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
        default:
            return .none
        }
    }

    private func navigateToHome() -> FlowContributors {
        let viewModel = HomeViewModel()
        let vc = HomeViewController(
            viewModel: viewModel
        )
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

    private func navigateToAlert() -> FlowContributors {
        let viewModel = AlertViewModel()
        let vc = AlertViewController(
            viewModel: viewModel
        )
        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }

}
