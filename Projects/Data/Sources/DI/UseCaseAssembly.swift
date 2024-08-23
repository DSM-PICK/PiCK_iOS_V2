import Foundation

import Domain

import Swinject

public final class UseCaseAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        //MARK: Auth
        container.register(LoginUseCase.self) { resolver in
            LoginUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }
        container.register(LogoutUseCase.self) { resolver in
            LogoutUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }
        container.register(RefreshTokenUseCase.self) { resolver in
            RefreshTokenUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }
        //MARK: SchoolMeal
        container.register(FetchSchoolMealUseCase.self) { resolver in
            FetchSchoolMealUseCase(repository: resolver.resolve(SchoolMealRepository.self)!)
        }
        //MARK: Schedule
        //timeTable
        container.register(FetchTodayTimeTableUseCase.self) { resolver in
            FetchTodayTimeTableUseCase(repository: resolver.resolve(TimeTableRepository.self)!)
        }

        //MARK: Apply
        //classRoom
        container.register(ClassroomMoveApplyUseCase.self) { resolver in
            ClassroomMoveApplyUseCase(repository: resolver.resolve(ClassroomRepository.self)!)
        }
        //outing
        container.register(OutingApplyUseCase.self) { resolver in
            OutingApplyUseCase(repository: resolver.resolve(OutingRepository.self)!)
        }
        //earlyLeave
        container.register(EarlyLeaveApplyUseCase.self) { resolver in
            EarlyLeaveApplyUseCase(repository: resolver.resolve(EarlyLeaveRepository.self)!)
        }

        //MARK: AllTab
        //profile
        container.register(FetchDetailProfileUseCase.self) { resolver in
            FetchDetailProfileUseCase(repository: resolver.resolve(ProfileRepository.self)!)
        }
        //bug
        container.register(BugImageUploadUseCase.self) { resolver in
            BugImageUploadUseCase(repository: resolver.resolve(BugRepository.self)!)
        }
        container.register(BugReportUseCase.self) { resolver in
            BugReportUseCase(repository: resolver.resolve(BugRepository.self)!)
        }
        //selfStudy
        container.register(FetchSelfStudyUseCase.self) { resolver in
            FetchSelfStudyUseCase(repository: resolver.resolve(SelfStudyRepository.self)!)
        }

        //MARK: Notice
        container.register(FetchNoticeListUseCase.self) { resolver in
            FetchNoticeListUseCase(repository: resolver.resolve(NoticeRepository.self)!)
        }
        container.register(FetchDetailNoticeUseCase.self) { resolver in
            FetchDetailNoticeUseCase(repository: resolver.resolve(NoticeRepository.self)!)
        }

    }

}
