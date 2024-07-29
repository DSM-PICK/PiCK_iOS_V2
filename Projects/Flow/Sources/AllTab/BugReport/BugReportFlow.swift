import UIKit

import RxFlow
import Swinject

import Core
import Presentation

public class BugReportFlow: Flow {
    public let container: Container
    private let rootViewController: BugReportViewController
    public var root: Presentable {
        return rootViewController
    }
    
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(BugReportViewController.self)!
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
        case .bugReportIsRequired:
            return navigateToBugReport()
        default:
            return .none
        }
    }

    private func navigateToBugReport() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

}
