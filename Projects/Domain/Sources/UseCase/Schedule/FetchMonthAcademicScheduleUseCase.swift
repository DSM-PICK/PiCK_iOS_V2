import Foundation

import RxSwift

import Core

public class FetchMonthAcademicScheduleUseCase {
    let repository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    public func execute(req: ScheduleRequestParams) -> Single<AcademicScheduleEntity> {
        return repository.fetchMonthAcademicSchedule(req: req)
    }
    
}
