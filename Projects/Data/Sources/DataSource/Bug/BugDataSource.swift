import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import Domain
import AppNetwork

protocol BugDataSource {
    func uploadImage(images: [Data]) -> Single<Response>
    func bugReport(req: BugRequestParams) -> Completable
}

class BugDataSourceImpl: BaseDataSource<BugAPI>, BugDataSource {

    func uploadImage(images: [Data]) -> Single<Response> {
        return request(.uploadImage(images: images))
            .filterSuccessfulStatusCodes()
    }

    func bugReport(req: BugRequestParams) -> Completable {
        return request(.bugReport(req: req))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
}
