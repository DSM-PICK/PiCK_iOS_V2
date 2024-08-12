import Foundation

import RxSwift

import Core
import Domain

class WeekendMealRepositoryImpl: WeekendMealRepository {
    let remoteDataSource: WeekendMealDataSource

    init(remoteDataSource: WeekendMealDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func weekendMealApply(status: String) -> Completable {
        return remoteDataSource.weekendMealApply(status: status)
    }

    func weekendMealCheck() -> Single<WeekendMealCheckEntity> {
        return remoteDataSource.weekendMealCheck()
            .map(WeekendMealCheckDTO.self)
            .map { $0.toDomain() }
    }
    
}
