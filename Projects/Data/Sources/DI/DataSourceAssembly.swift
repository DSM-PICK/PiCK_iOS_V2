import Foundation

import Core
import Domain

import Swinject

public final class DataSourceAssembly: Assembly {
    public init() {}

    private let keychain = { (resolver: Resolver) in
        resolver.resolve(Keychain.self)!
    }

    public func assemble(container: Container) {
        container.register(AuthDataSource.self) { resolver in
            AuthDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(ClassroomDataSource.self) { resolver in
            ClassroomDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(MainDataSource.self) { resolver in
            MainDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(NoticeDataSource.self) { resolver in
            NoticeDataSourceImpl(keychain: self.keychain(resolver))
        }

//        container.register(OutingDataSource.self) { resolver in
//            OutingDataSourceImpl(keychain: self.keychain(resolver))
//        }

        container.register(ProfileDataSource.self) { resolver in
            ProfileDataSourceImpl(keychain: self.keychain(resolver))
        }

//        container.register(ScheduleDataSource.self) { resolver in
//            ScheduleDataSourceImpl(keychain: self.keychain(resolver))
//        }

        container.register(SchoolMealDataSource.self) { resolver in
            SchoolMealDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(SelfStudyTeacherDataSource.self) { resolver in
            SelfStudyTeacherDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(WeekendMealDataSource.self) { resolver in
            WeekendMealDataSourceImpl(keychain: self.keychain(resolver))
        }

    }

}
