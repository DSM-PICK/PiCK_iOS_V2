import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

protocol SelfStudyTeacherDataSource {
    func fetchSelfStudyTeacher(date: String) -> Single<Response>
}

class SelfStudyTeacherDataSourceImpl: BaseDataSource<SelfStudyTeacherAPI>, SelfStudyTeacherDataSource {
    func fetchSelfStudyTeacher(date: String) -> Single<Response> {
        return request(.fetchSelfstudyTeacherCheck(date: date))
            .filterSuccessfulStatusCodes()
    }
}
