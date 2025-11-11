import Foundation

import Moya
import RxSwift

import AppNetwork
import Core
import Domain

class SchoolMealRepositoryImpl: SchoolMealRepository {
    private let remoteDataSource: SchoolMealDataSource
    private let localDataSource: SchoolMealLocalDataSource

    init(
        remoteDataSource: SchoolMealDataSource,
        localDataSource: SchoolMealLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetchSchoolMeal(date: String) -> Single<SchoolMealEntity> {
        return localDataSource.fetchSchoolMeal(date: date)
            .flatMap { [weak self] cachedMeal -> Single<SchoolMealEntity> in
                guard let self = self else {
                    return .error(NSError(domain: "SchoolMealRepository", code: -1))
                }

                if let cachedMeal = cachedMeal, !self.localDataSource.isCacheExpired(date: date) {
                    return .just(cachedMeal)
                }

                return self.fetchAndCacheFromRemote(date: date)
            }
    }

    private func fetchAndCacheFromRemote(date: String) -> Single<SchoolMealEntity> {
        return remoteDataSource.fetchSchoolMeal(date: date)
            .map(SchoolMealDTO.self)
            .flatMap { [weak self] dto -> Single<SchoolMealEntity> in
                guard let self = self else {
                    return .error(NSError(domain: "SchoolMealRepository", code: -1))
                }

                let realmObject = dto.toRealmObject()

                return self.localDataSource.saveSchoolMeal(date: date, meal: realmObject)
                    .andThen(Single.just(dto.toDomain()))
            }
    }

}
