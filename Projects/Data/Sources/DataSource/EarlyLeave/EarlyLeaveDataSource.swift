import Foundation

import RxSwift
import Moya
import RxMoya

import Domain
import AppNetwork

protocol EarlyLeaveDataSource {
    func earlyLeaveApply(req: EarlyLeaveApplyRequestParams) -> Completable
    func fetchEarlyLeavePass() -> Single<Response>
}

class EarlyLeaveDataSourceImpl: BaseDataSource<EarlyLeaveAPI>, EarlyLeaveDataSource {
    func earlyLeaveApply(req: EarlyLeaveApplyRequestParams) -> Completable {
        return request(.earlyLeaveApply(req: req))
        .asCompletable()
    }
    func fetchEarlyLeavePass() -> Single<Response> {
        return request(.fetchEarlyLeavePass)
            .filterSuccessfulStatusCodes()
    }
    
}
