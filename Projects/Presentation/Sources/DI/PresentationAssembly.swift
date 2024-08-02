import Foundation

import Swinject

import Core
import Domain

public final class PresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        //MARK: Onboarding
        container.register(OnboardingViewController.self) { resolver in
            OnboardingViewController(viewModel: resolver.resolve(OnboardingViewModel.self)!)
        }
        container.register(OnboardingViewModel.self) { resolver in
            OnboardingViewModel()
        }

        //MARK: Login
        container.register(LoginViewController.self) { resolver in
            LoginViewController(viewModel: resolver.resolve(LoginViewModel.self)!)
        }
        container.register(LoginViewModel.self) { resolver in
            LoginViewModel(
                loginUseCase: resolver.resolve(LoginUseCase.self)!
            )
        }

        //MARK: Home
        container.register(HomeViewController.self) { resolver in
            HomeViewController(viewModel: resolver.resolve(HomeViewModel.self)!)
        }
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel()
        }
        //Alert
        container.register(AlertViewController.self) { resolver in
            AlertViewController(viewModel: resolver.resolve(AlertViewModel.self)!)
        }
        container.register(AlertViewModel.self) { resolver in
            AlertViewModel()
        }

        //MARK: SchoolMeal
        container.register(SchoolMealViewController.self) { resolver in
            SchoolMealViewController(viewModel: resolver.resolve(SchoolMealViewModel.self)!)
        }
        container.register(SchoolMealViewModel.self) { resolver in
            SchoolMealViewModel()
        }

        //MARK: Apply
        container.register(ApplyViewController.self) { resolver in
            ApplyViewController(viewModel: resolver.resolve(ApplyViewModel.self)!)
        }
        container.register(ApplyViewModel.self) { resolver in
            ApplyViewModel()
        }
        //WeekendMeal
        container.register(WeekendMealViewController.self) { resolver in
            WeekendMealViewController(viewModel: resolver.resolve(WeekendMealViewModel.self)!)
        }
        container.register(WeekendMealViewModel.self) { resolver in
            WeekendMealViewModel()
        }
        //ClassRoomMove
        container.register(ClassRoomMoveViewController.self) { resolver in
            ClassRoomMoveViewController(viewModel: resolver.resolve(ClassRoomMoveViewModel.self)!)
        }
        container.register(ClassRoomMoveViewModel.self) { resolver in
            ClassRoomMoveViewModel()
        }

        //MARK: Schedule
        container.register(ScheduleViewController.self) { resolver in
            ScheduleViewController(viewModel: resolver.resolve(ScheduleViewModel.self)!)
        }
        container.register(ScheduleViewModel.self) { resolver in
            ScheduleViewModel()
        }

        //MARK: AllTab
        container.register(AllTabViewController.self) { resolver in
            AllTabViewController(viewModel: resolver.resolve(AllTabViewModel.self)!)
        }
        container.register(AllTabViewModel.self) { resolver in
            AllTabViewModel()
        }
        //Notice
        container.register(NoticeListViewController.self) { resolver in
            NoticeListViewController(viewModel: resolver.resolve(NoticeListViewModel.self)!)
        }
        container.register(NoticeListViewModel.self) { resolver in
            NoticeListViewModel()
        }
        container.register(NoticeDetailViewController.self) { resolver in
            NoticeDetailViewController(viewModel: resolver.resolve(NoticeDetailViewModel.self)!)
        }
        container.register(NoticeDetailViewModel.self) { resolver in
            NoticeDetailViewModel()
        }
        //SelfStudy
        container.register(SelfStudyViewController.self) { resolver in
            SelfStudyViewController(viewModel: resolver.resolve(SelfStudyViewModel.self)!)
        }
        container.register(SelfStudyViewModel.self) { resolver in
            SelfStudyViewModel()
        }
        //Bug
        container.register(BugReportViewController.self) { resolver in
            BugReportViewController(viewModel: resolver.resolve(BugReportViewModel.self)!)
        }
        container.register(BugReportViewModel.self) { resolver in
            BugReportViewModel()
        }
        //MyPage
        container.register(MyPageViewController.self) { resolver in
            MyPageViewController(viewModel: resolver.resolve(MyPageViewModel.self)!)
        }
        container.register(MyPageViewModel.self) { resolver in
            MyPageViewModel()
        }

    }

}
