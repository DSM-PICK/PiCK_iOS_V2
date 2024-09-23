import UIKit

import RxFlow
import Swinject

import Core
import Presentation

public class AlertFlow: Flow {
    public let container: Container
    private let rootViewController: AlertViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(AlertViewController.self)!
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }

        switch step {
        case .alertIsRequired:
            return navigateToAlert()
        default:
            return .none
        }
    }

    private func navigateToAlert() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

}
