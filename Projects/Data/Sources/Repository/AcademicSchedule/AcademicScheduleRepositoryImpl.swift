import Foundation

import RxSwift

import Core
import Domain

class AcademicScheduleRepositoryImpl: AcademicScheduleRepository {
    let remoteDataSource: AcademicScheduleDataSource

    init(remoteDataSource: AcademicScheduleDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchMonthAcademicSchedule(req: AcademicScheduleRequestParams) -> Single<AcademicScheduleEntity> {
        return remoteDataSource.fetchAcademicSchedule(req: req)
            .map(AcademicScheduleDTO.self)
            .map { $0.toDomain() }
    }

    func loadAcademicSchedule(date: String) -> Single<AcademicScheduleEntity> {
        return remoteDataSource.loadAcademicSchedule(date: date)
            .map(AcademicScheduleDTO.self)
            .map { $0.toDomain() }
    }

}
