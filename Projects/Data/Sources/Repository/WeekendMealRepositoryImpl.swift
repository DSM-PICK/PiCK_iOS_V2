import Foundation

import RxSwift

import Core
import Domain

class WeekendMealRepositoryImpl: WeekendMealRepository {
    let remoteDataSource: WeekendMealDataSource

    init(remoteDataSource: WeekendMealDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func weekendMealApply(status: WeekendMealType.RawValue) -> Completable {
        return remoteDataSource.weekendMealApply(status: status)
    }

    func weekendMealStatus() -> Single<WeekendMealStatusEntity> {
        return remoteDataSource.weekendMealStatus()
            .map(WeekendMealStatusDTO.self)
            .map { $0.toDomain() }
    }

    func weekendMealApplication() -> Single<WeekendMealApplicationEntity> {
        return remoteDataSource.weekendMealApplication()
            .map(WeekendMealApplicationDTO.self)
            .map { $0.toDomain() }
    }

    func weekendMealPeriod() -> Single<WeekendMealPeriodEntity> {
        return remoteDataSource.weekendMealPeriod()
            .map(WeekendMealPeriodDTO.self)
            .map { $0.toDomain() }
    }
}
