import Foundation

import RxSwift

import Core

public class FetchMonthAcademicScheduleUseCase {
    let repository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    public func execute(year: String, month: String) -> Single<AcademicScheduleEntity> {
        return repository.fetchMonthAcademicSchedule(year: year, month: month)
    }
    
}
