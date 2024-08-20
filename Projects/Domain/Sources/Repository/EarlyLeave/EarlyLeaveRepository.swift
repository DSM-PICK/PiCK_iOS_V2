import Foundation

import RxSwift

import Moya

public protocol EarlyLeaveRepository {
    func earlyLeaveApply(req: EarlyLeaveApplyRequestParams) -> Completable
    func fetchEarlyLeavePass() -> Single<OutingPassEntity>
}
