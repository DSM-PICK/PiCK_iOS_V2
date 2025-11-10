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

        container.register(HomeDataSource.self) { resolver in
            HomeDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(NoticeDataSource.self) { resolver in
            NoticeDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(BugDataSource.self) { resolver in
            BugDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(OutingDataSource.self) { resolver in
            OutingDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(EarlyLeaveDataSource.self) { resolver in
            EarlyLeaveDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(ProfileDataSource.self) { resolver in
            ProfileDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(TimeTableDataSource.self) { resolver in
            TimeTableDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(AcademicScheduleDataSource.self) { resolver in
            AcademicScheduleDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(SchoolMealDataSource.self) { resolver in
            SchoolMealDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(SchoolMealLocalDataSource.self) { _ in
            SchoolMealLocalDataSourceImpl()
        }

        container.register(SelfStudyDataSource.self) { resolver in
            SelfStudyTeacherDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(WeekendMealDataSource.self) { resolver in
            WeekendMealDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(NotificationDataSource.self) { resolver in
            NotificationDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(MailDataSource.self) { resolver in
            MailSourceImpl(keychain: self.keychain(resolver))
        }

    }

}
