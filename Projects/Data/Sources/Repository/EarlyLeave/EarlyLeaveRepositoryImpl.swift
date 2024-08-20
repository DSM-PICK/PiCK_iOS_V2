import Foundation

import RxSwift

import Domain

class EarlyLeaveRepositoryImpl: EarlyLeaveRepository {
    let remoteDataSource: EarlyLeaveDataSource

    init(remoteDataSource: EarlyLeaveDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func earlyLeaveApply(req: EarlyLeaveApplyRequestParams) -> Completable {
        return remoteDataSource.earlyLeaveApply(req: req)
    }

    func fetchEarlyLeavePass() -> Single<OutingPassEntity> {
        return remoteDataSource.fetchEarlyLeavePass()
            .map(OutingPassDTO.self)
            .map { $0.toDomain() }
    }
}
