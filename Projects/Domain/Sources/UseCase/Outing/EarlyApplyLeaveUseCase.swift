import Foundation

import RxSwift

public class EarlyLeaveApplyUseCase {

    let repository: EarlyLeaveRepository

    public init(repository: EarlyLeaveRepository) {
        self.repository = repository
    }

    public func execute(req: EarlyLeaveApplyRequestParams) -> Completable {
        return repository.earlyLeaveApply(req: req)
    }
}
