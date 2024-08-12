import Foundation

import RxSwift

public class EarlyLeaveApplyUseCase {

    let repository: OutingRepository

    public init(repository: OutingRepository) {
        self.repository = repository
    }

    public func execute(reason: String, startTime: String) -> Completable {
        return repository.earlyLeaveApply(reason: reason, startTime: startTime)
    }
}

