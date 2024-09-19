import Foundation

import RxSwift

import Domain

class HomeRepositoryImpl: HomeRepository {
    let remoteDataSource: HomeDataSource

    init(remoteDataSource: HomeDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchMainData() -> Single<HomeApplyStatusEntity> {
        return remoteDataSource.fetchHomeData()
            .map(HomeApplyStatusDTO.self)
            .map { $0.toDomain() }
    }

}
