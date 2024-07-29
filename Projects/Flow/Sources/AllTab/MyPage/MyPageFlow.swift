import UIKit

import RxFlow
import Swinject

import Core
import Presentation

public class MyPageFlow: Flow {
    public let container: Container
    private let rootViewController: MyPageViewController
    public var root: Presentable {
        return rootViewController
    }
    
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(MyPageViewController.self)!
    }
    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
        case .myPageIsRequired:
            return navigateToMyPage()
        default:
            return .none
        }
    }

    private func navigateToMyPage() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

}
