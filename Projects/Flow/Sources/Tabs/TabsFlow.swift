import UIKit

import RxFlow
import RxCocoa
import RxSwift

import Swinject

import Core
import DesignSystem
import Presentation

public class TabsFlow: Flow {
    public let container: Container
    private let rootViewController =  BaseTabBarController()
    public var root: Presentable {
        return self.rootViewController
    }

    public init(container: Container) {
        self.container = container
    }

    private lazy var homeFlow = HomeFlow(container: container)
    private lazy var schoolMealFlow = SchoolMealFlow(container: container)
    private lazy var applyFlow = ApplyFlow(container: container)
    private lazy var scheduleFlow = ScheduleFlow(container: container)
    private lazy var allTabFlow = AllTabFlow(container: container)

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PiCKStep else { return .none }

        switch step {
        case .tabIsRequired:
            return setupTabBar()
        case .appIsRequired:
            return dismissToOnbording()
        case .popIsRequired:
            return .end(forwardToParentFlowWithStep: PiCKStep.tabIsRequired)
        default:
            return .none
        }
    }

    private func setupTabBar() -> FlowContributors {
        Flows.use(
            homeFlow,
            schoolMealFlow,
            applyFlow,
            scheduleFlow,
            allTabFlow,
            when: .created
        ) { home, schoolMeal, apply, schedule, allTab in
            home.tabBarItem = PiCkTabBarTypeItem(.home)
            schoolMeal.tabBarItem = PiCkTabBarTypeItem(.schoolMeal)
            apply.tabBarItem = PiCkTabBarTypeItem(.apply)
            schedule.tabBarItem = PiCkTabBarTypeItem(.schedule)
            allTab.tabBarItem = PiCkTabBarTypeItem(.allTab)

            self.rootViewController.setViewControllers([
                home,
                schoolMeal,
                apply,
                schedule,
                allTab
            ], animated: false)
        }
        return .multiple(flowContributors: [
            .contribute(
                withNextPresentable: homeFlow,
                withNextStepper: OneStepper(withSingleStep: PiCKStep.homeIsRequired)
            ),
            .contribute(
                withNextPresentable: schoolMealFlow,
                withNextStepper: OneStepper(withSingleStep: PiCKStep.schoolMealIsRequired)
            ),
            .contribute(
                withNextPresentable: applyFlow,
                withNextStepper: OneStepper(withSingleStep: PiCKStep.applyIsRequired)
            ),
            .contribute(
                withNextPresentable: scheduleFlow,
                withNextStepper: OneStepper(withSingleStep: PiCKStep.scheduleIsRequired)
            ),
            .contribute(
                withNextPresentable: allTabFlow,
                withNextStepper: OneStepper(withSingleStep: PiCKStep.allTabIsRequired)
            )
        ])
    }

    private func dismissToOnbording() -> FlowContributors {
        UIView.transition(
            with: self.rootViewController.view.window!,
            duration: 0.5,
            options: .transitionCrossDissolve) {
                self.rootViewController.dismiss(animated: false)
            }

        return .end(forwardToParentFlowWithStep: PiCKStep.onboardingIsRequired)
    }

}
