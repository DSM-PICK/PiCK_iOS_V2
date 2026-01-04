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
        // Realm 캐싱 로직 주석처리 - NEIS API 직접 호출
        return fetchFromRemote(date: date)

        // 기존 Realm 캐싱 로직
//        return localDataSource.fetchSchoolMeal(date: date)
//            .flatMap { [weak self] cachedMeal -> Single<SchoolMealEntity> in
//                guard let self = self else {
//                    return .error(NSError(domain: "SchoolMealRepository", code: -1))
//                }
//
//                if let cachedMeal = cachedMeal, !self.localDataSource.isCacheExpired(date: date) {
//                    return .just(cachedMeal)
//                }
//
//                return self.fetchAndCacheFromRemote(date: date)
//            }
    }

    private func fetchFromRemote(date: String) -> Single<SchoolMealEntity> {
        return remoteDataSource.fetchSchoolMeal(date: date)
            .map(NEISMealResponse.self)
            .map { neisResponse -> SchoolMealDTO in
                return SchoolMealDTO(from: neisResponse, date: date)
            }
            .map { dto -> SchoolMealEntity in
                return dto.toDomain()
            }
    }

    // 기존 캐싱 로직 (주석처리)
//    private func fetchAndCacheFromRemote(date: String) -> Single<SchoolMealEntity> {
//        return remoteDataSource.fetchSchoolMeal(date: date)
//            .map(NEISMealResponse.self)
//            .map { neisResponse -> SchoolMealDTO in
//                return SchoolMealDTO(from: neisResponse, date: date)
//            }
//            .flatMap { [weak self] dto -> Single<SchoolMealEntity> in
//                guard let self = self else {
//                    return .error(NSError(domain: "SchoolMealRepository", code: -1))
//                }
//
//                let realmObject = dto.toRealmObject()
//
//                return self.localDataSource.saveSchoolMeal(date: date, meal: realmObject)
//                    .andThen(Single.just(dto.toDomain()))
//            }
//    }

}
