import UIKit

import RxFlow
import Swinject

import Core
import DesignSystem
import Presentation

public class ClassRoomMoveApplyFlow: Flow {
    public let container: Container
    private let rootViewController: ClassRoomMoveApplyViewController
    public var root: Presentable {
        return rootViewController
    }
    
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(ClassRoomMoveApplyViewController.self)!
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
        case .classRoomMoveApplyIsRequired:
            return navigateToClassRoomMoveApply()
        default:
            return .none
        }
    }

    private func navigateToClassRoomMoveApply() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

}
