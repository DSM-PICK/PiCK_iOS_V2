import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

protocol SelfStudyDataSource {
    func fetchSelfStudyTeacher(date: String) -> Single<Response>
}

class SelfStudyTeacherDataSourceImpl: BaseDataSource<SelfStudyAPI>, SelfStudyDataSource {
    func fetchSelfStudyTeacher(date: String) -> Single<Response> {
        return request(.fetchSelfStudyTeacher(date: date))
            .filterSuccessfulStatusCodes()
    }
}
