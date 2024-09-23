import Foundation

import RxSwift

public class FetchOutingPassUseCase {
    let repository: OutingRepository

    public init(repository: OutingRepository) {
        self.repository = repository
    }

    public func execute() -> Single<OutingPassEntity> {
        return repository.fetchOutingPass()
    }

}
