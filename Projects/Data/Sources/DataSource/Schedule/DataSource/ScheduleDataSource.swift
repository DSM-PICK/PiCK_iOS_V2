//import Foundation
//
//import RxSwift
//import Moya
//import RxMoya
//
//import AppNetwork
//import Core
//import Domain
//
//protocol ScheduleDataSource {
//    func fetchAcademicSchedule(year: String, month: MonthType.RawValue) -> Single<Response>
//    func fetchTodayTimeTable() -> Single<Response>
//    func fetchWeekTimeTable() -> Single<Response>
//}
//
//class ScheduleDataSourceImpl: BaseDataSource<ScheduleAPI>, ScheduleDataSource {
//    func fetchAcademicSchedule(year: String, month: MonthType.RawValue) -> Single<Response> {
//        return request(.fetchMonthAcademicSchedule(year: year, month: month))
//            .filterSuccessfulStatusCodes()
//    }
//    
//    func fetchTodayTimeTable() -> Single<Response> {
//        return request(.fetchTodayTimeTable)
//            .filterSuccessfulStatusCodes()
//    }
//    
//    func fetchWeekTimeTable() -> Single<Response> {
//        return request(.fetchWeekTimeTable)
//            .filterSuccessfulStatusCodes()
//    }
//    
//}
