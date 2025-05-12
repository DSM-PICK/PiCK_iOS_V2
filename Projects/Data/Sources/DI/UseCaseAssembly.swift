import Foundation

import Domain

import Swinject

public final class UseCaseAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        // MARK: Auth
        container.register(SigninUseCase.self) { resolver in
            SigninUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }
        container.register(LogoutUseCase.self) { resolver in
            LogoutUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }
        container.register(RefreshTokenUseCase.self) { resolver in
            RefreshTokenUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }
        // MARK: Home
        container.register(FetchApplyStatusUsecase.self) { resolver in
            FetchApplyStatusUsecase(repository: resolver.resolve(HomeRepository.self)!)
        }
        // MARK: SchoolMeal
        container.register(FetchSchoolMealUseCase.self) { resolver in
            FetchSchoolMealUseCase(repository: resolver.resolve(SchoolMealRepository.self)!)
        }

        // MARK: Schedule
        // timeTable
        container.register(FetchTodayTimeTableUseCase.self) { resolver in
            FetchTodayTimeTableUseCase(repository: resolver.resolve(TimeTableRepository.self)!)
        }

        // MARK: Apply
        // weekendMeal
        container.register(FetchWeekendMealStatusUseCase.self) { resolver in
            FetchWeekendMealStatusUseCase(repository: resolver.resolve(WeekendMealRepository.self)!)
        }
        container.register(WeekendMealApplyUseCase.self) { resolver in
            WeekendMealApplyUseCase(repository: resolver.resolve(WeekendMealRepository.self)!)
        }
        container.register(FetchWeekendMealApplicationUseCase.self) { resolver in
            FetchWeekendMealApplicationUseCase(repository: resolver.resolve(WeekendMealRepository.self)!)
        }
        container.register(FetchWeekendMealPeriodUseCase.self) { resolver in
            FetchWeekendMealPeriodUseCase(repository: resolver.resolve(WeekendMealRepository.self)!)
        }
        // classroom
        container.register(ClassroomMoveApplyUseCase.self) { resolver in
            ClassroomMoveApplyUseCase(repository: resolver.resolve(ClassroomRepository.self)!)
        }
        container.register(ClassroomReturnUseCase.self) { resolver in
            ClassroomReturnUseCase(repository: resolver.resolve(ClassroomRepository.self)!)
        }
        // outing
        container.register(OutingApplyUseCase.self) { resolver in
            OutingApplyUseCase(repository: resolver.resolve(OutingRepository.self)!)
        }
        container.register(FetchOutingPassUseCase.self) { resolver in
            FetchOutingPassUseCase(repository: resolver.resolve(OutingRepository.self)!)
        }
        // earlyLeave
        container.register(EarlyLeaveApplyUseCase.self) { resolver in
            EarlyLeaveApplyUseCase(repository: resolver.resolve(EarlyLeaveRepository.self)!)
        }
        container.register(FetchEarlyLeavePassUseCase.self) { resolver in
            FetchEarlyLeavePassUseCase(repository: resolver.resolve(EarlyLeaveRepository.self)!)
        }

        // MARK: AllTab
        // profile
        container.register(FetchSimpleProfileUseCase.self) { resolver in
            FetchSimpleProfileUseCase(repository: resolver.resolve(ProfileRepository.self)!)
        }
        container.register(FetchDetailProfileUseCase.self) { resolver in
            FetchDetailProfileUseCase(repository: resolver.resolve(ProfileRepository.self)!)
        }
        container.register(UploadProfileImageUseCase.self) { resolver in
            UploadProfileImageUseCase(repository: resolver.resolve(ProfileRepository.self)!)
        }
        // bug
        container.register(BugImageUploadUseCase.self) { resolver in
            BugImageUploadUseCase(repository: resolver.resolve(BugRepository.self)!)
        }
        container.register(BugReportUseCase.self) { resolver in
            BugReportUseCase(repository: resolver.resolve(BugRepository.self)!)
        }
        // selfStudy
        container.register(FetchSelfStudyUseCase.self) { resolver in
            FetchSelfStudyUseCase(repository: resolver.resolve(SelfStudyRepository.self)!)
        }
        // notification
        container.register(FetchNotificationStatus.self) { resolver in
            FetchNotificationStatus(repository: resolver.resolve(NotificationRepository.self)!)
        }
        container.register(NotificationSubscribeUseCase.self) { resolver in
            NotificationSubscribeUseCase(repository: resolver.resolve(NotificationRepository.self)!)
        }

        // MARK: Schedule
        container.register(FetchWeekTimeTableUseCase.self) { resolver in
            FetchWeekTimeTableUseCase(repository: resolver.resolve(TimeTableRepository.self)!)
        }
        container.register(FetchMonthAcademicScheduleUseCase.self) { resolver in
            FetchMonthAcademicScheduleUseCase(repository: resolver.resolve(AcademicScheduleRepository.self)!)
        }
        container.register(FetchAcademicScheduleUseCase.self) { resolver in
            FetchAcademicScheduleUseCase(repository: resolver.resolve(AcademicScheduleRepository.self)!)
        }

        // MARK: Notice
        container.register(FetchNoticeListUseCase.self) { resolver in
            FetchNoticeListUseCase(repository: resolver.resolve(NoticeRepository.self)!)
        }
        container.register(FetchSimpleNoticeListUseCase.self) { resolver in
            FetchSimpleNoticeListUseCase(repository: resolver.resolve(NoticeRepository.self)!)
        }
        container.register(FetchDetailNoticeUseCase.self) { resolver in
            FetchDetailNoticeUseCase(repository: resolver.resolve(NoticeRepository.self)!)
        }
    }

}
