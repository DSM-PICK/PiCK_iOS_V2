import Foundation

import RxSwift

public class EarlyLeaveApplyUseCase {

    let repository: OutingRepository

    public init(repository: OutingRepository) {
        self.repository = repository
    }

    public func execute(req: EarlyLeaveApplyRequestParams) -> Completable {
        return repository.earlyLeaveApply(req: req)
    }
}

