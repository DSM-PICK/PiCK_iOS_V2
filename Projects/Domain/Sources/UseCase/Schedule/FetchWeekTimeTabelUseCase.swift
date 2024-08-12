import Foundation

import RxSwift
 
import Core

public class FetchWeekTimeTableUseCase {
    let repository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    public func execute() -> Single<WeekTimeTableEntity> {
        return repository.fetchWeekTimeTable()
    }
    
}
