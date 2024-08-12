import Foundation

import RxSwift

public protocol OutingRepository {
    func outingApply(req: OutingApplyRequestParams) -> Completable
    func fetchOutingPass() -> Single<OutingPassEntity>
    func earlyLeaveApply(req: EarlyLeaveApplyRequestParams) -> Completable
    func fetchEarlyLeavePass() -> Single<OutingPassEntity>
}
