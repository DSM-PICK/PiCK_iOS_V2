import Foundation

import RxSwift

public class FetchSelfStudyUseCase {

    let repository: SelfStudyRepository
    
    public init(repository: SelfStudyRepository) {
        self.repository = repository
    }

    public func execute(date: String) -> Single<SelfStudyEntity> {
        return repository.fetchSelfStudyTeacher(date: date)
    }
    
}
