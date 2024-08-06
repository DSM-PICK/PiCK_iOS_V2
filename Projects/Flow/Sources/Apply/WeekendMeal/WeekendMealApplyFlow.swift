import UIKit

import RxFlow
import Swinject

import Core
import DesignSystem
import Presentation

public class WeekendMealApplyFlow: Flow {
    public let container: Container
    private let rootViewController: WeekendMealApplyViewController
    public var root: Presentable {
        return rootViewController
    }
    
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(WeekendMealApplyViewController.self)!
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
        case .weekendMealApplyIsRequired:
            return navigateToWeekendMealApply()
        default:
            return .none
        }
    }

    private func navigateToWeekendMealApply() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

}
