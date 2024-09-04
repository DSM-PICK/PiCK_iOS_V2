import Foundation

import RxSwift

import Domain

class MainRepositoryImpl: HomeRepository {
    let remoteDataSource: HomeDataSource

    init(remoteDataSource: HomeDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchMainData() -> Single<HomeApplyStatusEntity?> {
        return remoteDataSource.fetchMainData()
            .map(HomeApplyStatusDTO.self)
            .map { $0.toDomain() }
    }
    
}
