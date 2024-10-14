import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Core
import Domain

protocol AcademicScheduleDataSource {
    func fetchAcademicSchedule(req: AcademicScheduleRequestParams) -> Single<Response>
    func loadAcademicSchedule(date: String) -> Single<Response>
}

class AcademicScheduleDataSourceImpl: BaseDataSource<AcademicScheduleAPI>, AcademicScheduleDataSource {
    func fetchAcademicSchedule(req: AcademicScheduleRequestParams) -> Single<Response> {
        return request(.fetchMonthAcademicSchedule(req: req))
            .filterSuccessfulStatusCodes()
    }

    func loadAcademicSchedule(date: String) -> Single<Response> {
        return request(.loadAcademicSchedule(date: date))
            .filterSuccessfulStatusCodes()
    }

}
