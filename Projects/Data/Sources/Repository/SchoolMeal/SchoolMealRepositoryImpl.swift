import Foundation

import Moya
import RxSwift

import AppNetwork
import Core
import Domain

class SchoolMealRepositoryImpl: SchoolMealRepository {
    private let remoteDataSource: SchoolMealDataSource

    init(remoteDataSource: SchoolMealDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchSchoolMeal(date: String) -> Single<SchoolMealEntity> {
        return remoteDataSource.fetchSchoolMeal(date: date)
            .map(SchoolMealDTO.self)
            .map { $0.toDomain() }
    }
    
}
