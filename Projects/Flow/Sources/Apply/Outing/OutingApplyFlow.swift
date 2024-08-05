import UIKit

import RxFlow
import Swinject

import Core
import DesignSystem
import Presentation

public class OutingApplyFlow: Flow {
    public let container: Container
    private let rootViewController: OutingApplyViewController
    public var root: Presentable {
        return rootViewController
    }
    
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(OutingApplyViewController.self)!
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
        case .outingApplyIsRequired:
            return navigateToOutingApply()
        case .timeSelectAlertIsRequired:
            return presentModal()
        default:
            return .none
        }
    }

    private func navigateToOutingApply() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    private func presentModal() -> FlowContributors {
        let modal = PiCKApplyTimePickerAlert()
        self.rootViewController.presentAsCustomDents(view: modal, height: 288)
        return .none
    }

}
