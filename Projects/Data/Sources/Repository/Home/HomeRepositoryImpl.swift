import Foundation

import RxSwift

import Domain

class HomeRepositoryImpl: HomeRepository {
    let remoteDataSource: HomeDataSource

    init(remoteDataSource: HomeDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchApplyStatus() -> Single<HomeApplyStatusEntity> {
        return Single.just(remoteDataSource.fetchApplyStatus())
    }

}
