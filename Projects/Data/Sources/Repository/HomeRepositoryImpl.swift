import Foundation

import RxSwift

import Domain

class HomeRepositoryImpl: HomeRepository {
    let remoteDataSource: HomeDataSource

    init(remoteDataSource: HomeDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchApplyStatus() -> Observable<HomeApplyStatusEntity?> {
        return remoteDataSource.fetchApplyStatus()
    }
}
