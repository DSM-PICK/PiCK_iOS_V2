import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Core
import Domain

protocol TimeTableDataSource {
    func fetchTodayTimeTable() -> Single<Response>
    func fetchWeekTimeTable() -> Single<Response>
}

class TimeTableDataSourceImpl: BaseDataSource<TimeTableAPI>, TimeTableDataSource {
    func fetchTodayTimeTable() -> Single<Response> {
        return request(.fetchTodayTimeTable)
            .filterSuccessfulStatusCodes()
    }

    func fetchWeekTimeTable() -> Single<Response> {
        return request(.fetchWeekTimeTable)
            .filterSuccessfulStatusCodes()
    }

}
