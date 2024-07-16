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
//class ScheduleDataSource {
//    private let provider = MoyaProvider<ScheduelAPI>(plugins: [MoyaLoggingPlugin()])
//
//    static let shared = ScheduleDataSource()
//    
//    func fetchAcademicSchedule(year: String, month: MonthType.RawValue) -> Single<Response> {
//        return provider.rx.request(.fetchMonthAcademicSchedule(year: year, month: month))
//            .filterSuccessfulStatusCodes()
//    }
//    
//    func fetchTodayTimeTable() -> Single<Response> {
//        return provider.rx.request(.fetchTodayTimeTable)
//            .filterSuccessfulStatusCodes()
//    }
//    
//    func fetchWeekTimeTable() -> Single<Response> {
//        return provider.rx.request(.fetchWeekTimeTable)
//            .filterSuccessfulStatusCodes()
//    }
//    
//}
