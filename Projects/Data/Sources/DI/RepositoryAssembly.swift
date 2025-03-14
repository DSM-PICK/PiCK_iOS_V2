import Foundation

import Swinject

import Domain

public final class RepositoryAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(AuthRepository.self) { resolver in
            AuthRepositoryImpl(remoteDataSource: resolver.resolve(AuthDataSource.self)!)
        }

        container.register(ClassroomRepository.self) { resolver in
            ClassroomRepositoryImpl(remoteDataSource: resolver.resolve(ClassroomDataSource.self)!)
        }

        container.register(HomeRepository.self) { resolver in
            HomeRepositoryImpl(remoteDataSource: resolver.resolve(HomeDataSource.self)!)
        }

        container.register(NoticeRepository.self) { resolver in
            NoticeRepositoryImpl(remoteDataSource: resolver.resolve(NoticeDataSource.self)!)
        }

        container.register(BugRepository.self) { resolver in
            BugRepositoryImpl(remoteDataSource: resolver.resolve(BugDataSource.self)!)
        }

        container.register(OutingRepository.self) { resolver in
            OutingRepositoryImpl(remoteDataSource: resolver.resolve(OutingDataSource.self)!)
        }

        container.register(EarlyLeaveRepository.self) { resolver in
            EarlyLeaveRepositoryImpl(remoteDataSource: resolver.resolve(EarlyLeaveDataSource.self)!)
        }

        container.register(ProfileRepository.self) { resolver in
            ProfileRepositoryImpl(remoteDataSource: resolver.resolve(ProfileDataSource.self)!)
        }

        container.register(TimeTableRepository.self) { resolver in
            TimeTableRepositoryImpl(remoteDataSource: resolver.resolve(TimeTableDataSource.self)!)
        }

        container.register(AcademicScheduleRepository.self) { resolver in
            AcademicScheduleRepositoryImpl(
                remoteDataSource: resolver.resolve(AcademicScheduleDataSource.self)!
            )
        }

        container.register(SchoolMealRepository.self) { resolver in
            SchoolMealRepositoryImpl(remoteDataSource: resolver.resolve(SchoolMealDataSource.self)!)
        }

        container.register(SelfStudyRepository.self) { resolver in
            SelfStudyRepositoryImpl(remoteDataSource: resolver.resolve(SelfStudyDataSource.self)!)
        }

        container.register(WeekendMealRepository.self) { resolver in
            WeekendMealRepositoryImpl(remoteDataSource: resolver.resolve(WeekendMealDataSource.self)!)
        }

        container.register(NotificationRepository.self) { resolver in
            NotificationRepositoryImpl(remoteDataSource: resolver.resolve(NotificationDataSource.self)!)
        }

    }
}
