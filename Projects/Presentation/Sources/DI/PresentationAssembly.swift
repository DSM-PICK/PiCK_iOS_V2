import Foundation

import Swinject

import Core
import Domain

public final class PresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        // MARK: Onboarding
        container.register(OnboardingViewController.self) { resolver in
            OnboardingViewController(viewModel: resolver.resolve(OnboardingViewModel.self)!)
        }
        container.register(OnboardingViewModel.self) { resolver in
            OnboardingViewModel(
                refreshTokenUseCase: resolver.resolve(RefreshTokenUseCase.self)!,
                signinUseCase: resolver.resolve(SigninUseCase.self)!
            )
        }

        // MARK: Signin
        container.register(SigninViewController.self) { resolver in
            SigninViewController(reactor: resolver.resolve(SigninReactor.self)!)
        }
        container.register(SigninReactor.self) { resolver in
            SigninReactor(
                signinUseCase: resolver.resolve(SigninUseCase.self)!
            )
        }

        // MARK: Signup
        container.register(VerifyEmailViewController.self) { resolver in
            VerifyEmailViewController(reactor: resolver.resolve(VerifyEmailReactor.self)!)
        }
        container.register(VerifyEmailReactor.self) { resolver in
            VerifyEmailReactor(
                verifyEmailCodeUseCase: resolver.resolve(VerifyEmailCodeUseCase.self)!,
                mailCodeCheckUseCase: resolver.resolve(MailCodeCheckUseCase.self)!
            )
        }
        container.register(PasswordSettingViewModel.self) { resolver in
            PasswordSettingViewModel()
        }
        container.register(PasswordSettingViewController.self) { resolver in
            PasswordSettingViewController(viewModel: resolver.resolve(PasswordSettingViewModel.self)!)
        }
        container.register(InfoSettingViewModel.self) { resolver in
            InfoSettingViewModel(
                signupUseCase: resolver.resolve(SignupUseCase.self)!,
                signinUseCase: resolver.resolve(SigninUseCase.self)!
            )
        }
        container.register(InfoSettingViewController.self) { resolver in
            InfoSettingViewController(viewModel: resolver.resolve(InfoSettingViewModel.self)!)
        }

        // MARK: Home
        container.register(HomeViewController.self) { resolver in
            HomeViewController(viewModel: resolver.resolve(HomeViewModel.self)!)
        }
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                fetchApplyStatusUseCase: resolver.resolve(FetchApplyStatusUsecase.self)!,
                fetchWeekendMealPeriodUseCase: resolver.resolve(FetchWeekendMealPeriodUseCase.self)!,
                timeTableUseCase: resolver.resolve(FetchTodayTimeTableUseCase.self)!,
                schoolMealUseCase: resolver.resolve(FetchSchoolMealUseCase.self)!,
                noticeListUseCase: resolver.resolve(FetchSimpleNoticeListUseCase.self)!,
                selfStudyUseCase: resolver.resolve(FetchSelfStudyUseCase.self)!,
                fetchOutingPassUseCase: resolver.resolve(FetchOutingPassUseCase.self)!,
                fetchEarlyLeavePassUseCase: resolver.resolve(FetchEarlyLeavePassUseCase.self)!,
                classroomReturnUseCase: resolver.resolve(ClassroomReturnUseCase.self)!,
                fetchProfileUseCase: resolver.resolve(FetchSimpleProfileUseCase.self)!
            )
        }
        // Alert
        container.register(AlertViewController.self) { resolver in
            AlertViewController(viewModel: resolver.resolve(AlertViewModel.self)!)
        }
        container.register(AlertViewModel.self) { resolver in
            AlertViewModel()
        }

        // MARK: SchoolMeal
        container.register(SchoolMealViewController.self) { resolver in
            SchoolMealViewController(viewModel: resolver.resolve(SchoolMealViewModel.self)!)
        }
        container.register(SchoolMealViewModel.self) { resolver in
            SchoolMealViewModel(
                fetchSchoolMealUseCase: resolver.resolve(FetchSchoolMealUseCase.self)!
            )
        }

        // MARK: Apply
        container.register(ApplyViewController.self) { resolver in
            ApplyViewController(viewModel: resolver.resolve(ApplyViewModel.self)!)
        }
        container.register(ApplyViewModel.self) { resolver in
            ApplyViewModel()
        }
        // WeekendMeal
        container.register(WeekendMealApplyViewController.self) { resolver in
            WeekendMealApplyViewController(viewModel: resolver.resolve(WeekendMealApplyViewModel.self)!)
        }
        container.register(WeekendMealApplyViewModel.self) { resolver in
            WeekendMealApplyViewModel(
                weekendMealStatusUseCase: resolver.resolve(FetchWeekendMealStatusUseCase.self)!,
                weekendMealApplyUseCase: resolver.resolve(WeekendMealApplyUseCase.self)!,
                weekendMealApplicationUseCase: resolver.resolve(FetchWeekendMealApplicationUseCase.self)!
            )
        }
        // ClassoomMove
        container.register(ClassroomMoveApplyViewController.self) { resolver in
            ClassroomMoveApplyViewController(viewModel: resolver.resolve(ClassroomMoveApplyViewModel.self)!)
        }
        container.register(ClassroomMoveApplyViewModel.self) { resolver in
            ClassroomMoveApplyViewModel(
                classRoomMoveApplyUseCase: resolver.resolve(ClassroomMoveApplyUseCase.self)!)
        }
        // Outing
        container.register(OutingApplyViewController.self) { resolver in
            OutingApplyViewController(viewModel: resolver.resolve(OutingApplyViewModel.self)!)
        }
        container.register(OutingApplyViewModel.self) { resolver in
            OutingApplyViewModel(outingApplyUseCase: resolver.resolve(OutingApplyUseCase.self)!)
        }
        // EarlyLeave
        container.register(EarlyLeaveApplyViewController.self) { resolver in
            EarlyLeaveApplyViewController(viewModel: resolver.resolve(EarlyLeaveApplyViewModel.self)!)
        }
        container.register(EarlyLeaveApplyViewModel.self) { resolver in
            EarlyLeaveApplyViewModel(earlyLeaveApplyUseCase: resolver.resolve(EarlyLeaveApplyUseCase.self)!)
        }

        // MARK: Schedule
        container.register(ScheduleViewController.self) { resolver in
            ScheduleViewController(viewModel: resolver.resolve(ScheduleViewModel.self)!)
        }
        container.register(ScheduleViewModel.self) { resolver in
            ScheduleViewModel(
                fetchWeekTimeTableUseCase: resolver.resolve(FetchWeekTimeTableUseCase.self)!,
                fetchMonthAcademicScheduleUseCase: resolver.resolve(FetchMonthAcademicScheduleUseCase.self)!,
                fetchAcademicScheduleUseCase: resolver.resolve(FetchAcademicScheduleUseCase.self)!
            )
        }

        // MARK: AllTab
        container.register(AllTabViewController.self) { resolver in
            AllTabViewController(viewModel: resolver.resolve(AllTabViewModel.self)!)
        }
        container.register(AllTabViewModel.self) { resolver in
            AllTabViewModel(
                fetchProfileUsecase: resolver.resolve(FetchSimpleProfileUseCase.self)!,
                logoutUseCase: resolver.resolve(LogoutUseCase.self)!
            )
        }
        // Notice
        container.register(NoticeListViewController.self) { resolver in
            NoticeListViewController(viewModel: resolver.resolve(NoticeListViewModel.self)!)
        }
        container.register(NoticeListViewModel.self) { resolver in
            NoticeListViewModel(noticeListUseCase: resolver.resolve(FetchNoticeListUseCase.self)!)
        }
        container.register(NoticeDetailViewController.self) { resolver in
            NoticeDetailViewController(viewModel: resolver.resolve(NoticeDetailViewModel.self)!)
        }
        container.register(NoticeDetailViewModel.self) { resolver in
            NoticeDetailViewModel(noticeDetailUseCase: resolver.resolve(FetchDetailNoticeUseCase.self)!)
        }
        // SelfStudy
        container.register(SelfStudyViewController.self) { resolver in
            SelfStudyViewController(viewModel: resolver.resolve(SelfStudyViewModel.self)!)
        }
        container.register(SelfStudyViewModel.self) { resolver in
            SelfStudyViewModel(
                fetchSelfStudyUseCase: resolver.resolve(FetchSelfStudyUseCase.self)!
            )
        }
        // Bug
        container.register(BugReportViewController.self) { resolver in
            BugReportViewController(viewModel: resolver.resolve(BugReportViewModel.self)!)
        }
        container.register(BugReportViewModel.self) { resolver in
            BugReportViewModel(
                bugImageUploadUseCase: resolver.resolve(BugImageUploadUseCase.self)!,
                bugReportUseCase: resolver.resolve(BugReportUseCase.self)!
            )
        }
        // CustomSetting
        container.register(CustomSettingViewController.self) { resolver in
            CustomSettingViewController(viewModel: resolver.resolve(CustomSettingViewModel.self)!)
        }
        container.register(CustomSettingViewModel.self) { resolver in
            CustomSettingViewModel()
        }
        // Notification
        container.register(NotificationSettingViewController.self) { resolver in
            NotificationSettingViewController(viewModel: resolver.resolve(NotificationSettingViewModel.self)!)
        }
        container.register(NotificationSettingViewModel.self) { resolver in
            NotificationSettingViewModel(
                fetchNotificationStatusUseCase: resolver.resolve(FetchNotificationStatus.self)!,
                notificationSubscribeUseCase: resolver.resolve(NotificationSubscribeUseCase.self)!
            )
        }
        // ChangePassword
        container.register(ChangePasswordViewModel.self) { resolver in
            ChangePasswordViewModel()
        }
        container.register(ChangePasswordViewController.self) { resolver in
            ChangePasswordViewController(viewModel: resolver.resolve(ChangePasswordViewModel.self)!)
        }
        container.register(NewPasswordViewModel.self) { resolver in
            NewPasswordViewModel()
        }
        container.register(NewPasswordViewController.self) { resolver in
            NewPasswordViewController(viewModel: resolver.resolve(NewPasswordViewModel.self)!)
        }
        // MyPage
        container.register(MyPageViewController.self) { resolver in
            MyPageViewController(viewModel: resolver.resolve(MyPageViewModel.self)!)
        }
        container.register(MyPageViewModel.self) { resolver in
            MyPageViewModel(
                profileUsecase: resolver.resolve(FetchDetailProfileUseCase.self)!,
                uploadProfileImageUseCase: resolver.resolve(UploadProfileImageUseCase.self)!
            )
        }
    }

}
