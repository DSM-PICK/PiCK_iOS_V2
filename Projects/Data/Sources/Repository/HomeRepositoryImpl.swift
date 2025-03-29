import Foundation

import RxSwift

import Domain

class HomeRepositoryImpl: HomeRepository {
    let homeDataSource: HomeDataSource

    init(homeDataSource: HomeDataSource) {
        self.homeDataSource = homeDataSource
    }

    func fetchApplyStatus() -> Observable<HomeApplyStatusEntity?> {
        return homeDataSource.fetchApplyStatus()
    }
}
