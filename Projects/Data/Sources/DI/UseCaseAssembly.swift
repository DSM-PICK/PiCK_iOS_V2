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
        //TimeTable
        container.register(FetchTodayTimeTableUseCase.self) { resolver in
            FetchTodayTimeTableUseCase(repository: resolver.resolve(TimeTableRepository.self)!)
        }

        //MARK: Apply
        //ClassRoom
        container.register(ClassroomMoveApplyUseCase.self) { resolver in
            ClassroomMoveApplyUseCase(repository: resolver.resolve(ClassroomRepository.self)!)
        }

        //MARK: AllTab
        container.register(FetchDetailProfileUseCase.self) { resolver in
            FetchDetailProfileUseCase(repository: resolver.resolve(ProfileRepository.self)!)
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
