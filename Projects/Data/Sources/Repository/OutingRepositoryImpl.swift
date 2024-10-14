import Foundation

import RxSwift

import Domain

class OutingRepositoryImpl: OutingRepository {
    let remoteDataSource: OutingDataSource

    init(remoteDataSource: OutingDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func outingApply(req: OutingApplyRequestParams) -> Completable {
        return remoteDataSource.outingApply(req: req)
    }

    func fetchOutingPass() -> Single<OutingPassEntity> {
        return remoteDataSource.fetchOutingPass()
            .map(OutingPassDTO.self)
            .map { $0.toDomain() }
    }
}
