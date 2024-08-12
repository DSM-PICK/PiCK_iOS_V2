import Foundation

import RxSwift

public protocol OutingRepository {
    func outingApply(request: OutingApplyRequestParams) -> Completable
    func fetchOutingPass() -> Single<OutingPassEntity>
    func earlyLeaveApply(request: EarlyLeaveApplyRequestParams) -> Completable
    func fetchEarlyLeavePass() -> Single<OutingPassEntity>
}
