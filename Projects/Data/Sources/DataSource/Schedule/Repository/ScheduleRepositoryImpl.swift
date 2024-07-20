//import Foundation
//
//import RxSwift
//
//import Core
//import Domain
//
//class ScheduleRepositoryImpl: ScheduleRepository {
//    let remoteDataSource: ScheduleDataSourceImpl
//
//    init(remoteDataSource: ScheduleDataSourceImpl) {
//        self.remoteDataSource = remoteDataSource
//    }
//
//    func fetchMonthAcademicSchedule(year: String, month: String) -> Single<AcademicScheduleEntity> {
//        return remoteDataSource.fetchAcademicSchedule(
//            year: year,
//            month: month
//        )
//            .map(MonthAcademicScheduleDTO.self)
//            .map { $0.toDomain() }
//    }
//    
//    func fetchTodayTimeTable() -> Single<TimeTableEntity> {
//        return remoteDataSource.fetchTodayTimeTable()
//            .map(TimeTableDTO.self)
//            .map { $0.toDomain() }
//    }
//    
//    func fetchWeekTimeTable() -> Single<WeekTimeTableEntity> {
//        return remoteDataSource.fetchWeekTimeTable()
//            .map(WeekTimeTableDTO.self)
//            .map { $0.toDomain() }
//    }
//    
//}
