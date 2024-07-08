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
            return navigateToHome()
        default:
            return .none
        }
    }
    
    private func navigateToHome() -> FlowContributors {
        let viewModel = ApplyViewModel()
        let vc = ApplyViewController(
            viewModel: viewModel
        )
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: vc.viewModel
        ))
    }
    
}
