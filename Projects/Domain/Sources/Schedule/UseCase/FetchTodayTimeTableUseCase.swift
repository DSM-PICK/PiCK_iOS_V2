import Foundation

import RxSwift
 
import Core

public class FetchTodayTimeTableUseCase {
    let repository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    public func execute() -> Single<TimeTableEntity> {
        return repository.fetchTodayTimeTable()
    }
    
}
