import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

class SelfStudyTeacherDataSource {
    private let provider = MoyaProvider<SelfStudyTeacherAPI>(plugins: [MoyaLoggingPlugin()])

    static let shared = SelfStudyTeacherDataSource()
    
    func fetchSelfStudyTeacher(date: String) -> Single<Response> {
        return provider.rx.request(.fetchSelfstudyTeacherCheck(date: date))
            .filterSuccessfulStatusCodes()
    }
}
