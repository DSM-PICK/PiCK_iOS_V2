import Foundation

import RxSwift

public protocol OutingRepository {
    func outingApply(reason: String, startTime: String, endTime: String) -> Completable
    func fetchOutingPass() -> Single<OutingPassEntity>
    func earlyLeaveApply(reason: String, startTime: String) -> Completable
    func fetchEarlyLeavePass() -> Single<OutingPassEntity>
}
