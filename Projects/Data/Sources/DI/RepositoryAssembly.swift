import Foundation

import Swinject

import Domain

public final class RepositoryAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(AuthRepository.self) { resolver in
            AuthRepositoryImpl(remoteDataSource: resolver.resolve(AuthDataSource.self)!)
        }

//        container.register(ClassroomRepository.self) { resolver in
//            ClassroomRepositoryImpl(remoteDataSource: resolver.resolve(ClassroomDataSource.self)!)
//        }

//        container.register(MainRepository.self) { resolver in
//            m(remoteDataSource: resolver.resolve(AuthDataSource.self)!)
//        }

        container.register(NoticeRepository.self) { resolver in
            NoticeRepositoryImpl(remoteDataSource: resolver.resolve(NoticeDataSource.self)!)
        }

//        container.register(OutingRepository.self) { resolver in
//            OutingRepositoryImpl(remoteDataSource: resolver.resolve(AuthDataSource.self)!)
//        }

        container.register(ProfileRepository.self) { resolver in
            ProfileRepositoryImpl(remoteDataSource: resolver.resolve(ProfileDataSource.self)!)
        }

//        container.register(ScheduleRepository.self) { resolver in
//            ScheduleRepositoryImpl(remoteDataSource: resolver.resolve(ScheduleDataSource.self)!)
//        }

        container.register(SchoolMealRepository.self) { resolver in
            SchoolMealRepositoryImpl(remoteDataSource: resolver.resolve(SchoolMealDataSource.self)!)
        }

        container.register(SelfStudyRepository.self) { resolver in
            SelfStudyTeacherRepositoryImpl(remoteDataSource: resolver.resolve(SelfStudyTeacherDataSource.self)!)
        }

//        container.register(WeekendMealRepository.self) { resolver in
//            WeekendMealRepositoryImpl(remoteDataSource: resolver.resolve(WeekenDataSource.self)!)
//        }

    }
}
