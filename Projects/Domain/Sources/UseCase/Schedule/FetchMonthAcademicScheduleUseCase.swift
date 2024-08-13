import Foundation

import RxSwift

import Core

public class FetchMonthAcademicScheduleUseCase {
    let repository: AcademicScheduleRepository
    
    public init(repository: AcademicScheduleRepository) {
        self.repository = repository
    }
    
    public func execute(req: AcademicScheduleRequestParams) -> Single<AcademicScheduleEntity> {
        return repository.fetchMonthAcademicSchedule(req: req)
    }
    
}
