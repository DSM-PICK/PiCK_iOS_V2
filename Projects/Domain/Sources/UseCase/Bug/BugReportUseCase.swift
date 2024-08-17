import Foundation

import RxSwift

import Moya

public class BugReportUseCase {
    let repository: BugRepository
    
    public init(repository: BugRepository) {
        self.repository = repository
    }

    public func execute(req: BugRequestParams) -> Completable {
        return repository.bugReport(req: req)
    }

}
