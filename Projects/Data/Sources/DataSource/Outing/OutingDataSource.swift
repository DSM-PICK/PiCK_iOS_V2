import Foundation

import RxSwift
import Moya
import RxMoya

import Domain
import AppNetwork

protocol OutingDataSource {
    func outingApply(req: OutingApplyRequestParams) -> Completable
    func fetchOutingPass() -> Single<Response>
}

class OutingDataSourceImpl: BaseDataSource<OutingAPI>, OutingDataSource {
    func outingApply(req: OutingApplyRequestParams) -> Completable {
        return request(.outingApply(req: req))
        .asCompletable()
    }
    func fetchOutingPass() -> Single<Response> {
        return request(.fetchOutingPass)
            .filterSuccessfulStatusCodes()
    }
}
