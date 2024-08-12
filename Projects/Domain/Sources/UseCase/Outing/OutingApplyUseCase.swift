import Foundation

import RxSwift

public class OutingApplyUseCase {

    let repository: OutingRepository

    public init(repository: OutingRepository) {
        self.repository = repository
    }

    public func execute(req: OutingApplyRequestParams) -> Completable {
        return repository.outingApply(req: req)
    }
}
