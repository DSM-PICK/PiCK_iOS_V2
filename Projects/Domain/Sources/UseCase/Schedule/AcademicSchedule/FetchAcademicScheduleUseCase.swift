import Foundation

import RxSwift

import Core

public class FetchAcademicScheduleUseCase {
    let repository: AcademicScheduleRepository

    public init(repository: AcademicScheduleRepository) {
        self.repository = repository
    }

    public func execute(date: String) -> Single<AcademicScheduleEntity> {
        return repository.loadAcademicSchedule(date: date)
    }

}
