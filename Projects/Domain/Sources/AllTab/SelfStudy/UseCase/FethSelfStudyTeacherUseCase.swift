import Foundation

import RxSwift

public class FetchSelfStudyTeacherUseCase {

    let repository: SelfStudyRepository
    
    public init(repository: SelfStudyRepository) {
        self.repository = repository
    }

    public func execute(date: String) -> Single<SelfStudyTeacherEntity> {
        return repository.fetchSelfStudyTeacher(date: date)
    }
    
}
