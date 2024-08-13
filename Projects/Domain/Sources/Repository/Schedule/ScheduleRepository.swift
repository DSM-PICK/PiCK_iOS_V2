import Foundation

import RxSwift

import Core

public protocol AcademicScheduleRepository {
    func fetchMonthAcademicSchedule(req: AcademicScheduleRequestParams) -> Single<AcademicScheduleEntity>
}
