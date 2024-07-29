import UIKit

import RxFlow
import Swinject

import Core
import Presentation

public class SelfStudyFlow: Flow {
    public let container: Container
    private let rootViewController: SelfStudyViewController
    public var root: Presentable {
        return rootViewController
    }
    
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(SelfStudyViewController.self)!
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
        case .selfStudyIsRequired:
            return navigateToSelfStudy()
        default:
            return .none
        }
    }

    private func navigateToSelfStudy() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

}
