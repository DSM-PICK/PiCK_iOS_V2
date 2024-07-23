import Foundation

import Swinject

import Core
import Domain

public final class PresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        //onboarding
        container.register(OnboardingViewController.self) { resolver in
            OnboardingViewController(viewModel: resolver.resolve(OnboardingViewModel.self)!)
        }
        container.register(OnboardingViewModel.self) { resolver in
            OnboardingViewModel()
        }
        
        //login
        container.register(LoginViewController.self) { resolver in
            LoginViewController(viewModel: resolver.resolve(LoginViewModel.self)!)
        }
        container.register(LoginViewModel.self) { resolver in
            LoginViewModel(loginUseCase: resolver.resolve(LoginUseCase.self)!)
        }
        
        //notice
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
        
        //allTab
        //bug
        container.register(BugReportViewController.self) { resolver in
            BugReportViewController(viewModel: resolver.resolve(BugReportViewModel.self)!)
        }
        container.register(BugReportViewModel.self) { resolver in
            BugReportViewModel()
        }
        //myPage
        container.register(MyPageViewController.self) { resolver in
            MyPageViewController(viewModel: resolver.resolve(MyPageViewModel.self)!)
        }
        container.register(MyPageViewModel.self) { resolver in
            MyPageViewModel()
        }

    }

}
