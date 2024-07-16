import Foundation

import RxSwift

public class OutingApplyUseCase {

    let repository: OutingRepository

    public init(repository: OutingRepository) {
        self.repository = repository
    }

    public func execute(reason: String, startTime: String, endTime: String) -> Completable {
        return repository.outingApply(reason: reason, startTime: startTime, endTime: endTime)
    }
}
