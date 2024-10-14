import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import Domain
import AppNetwork

protocol BugDataSource {
    func uploadImage(images: [Data]) -> Single<[String]>
    func bugReport(req: BugRequestParams) -> Completable
}

class BugDataSourceImpl: BaseDataSource<BugAPI>, BugDataSource {
    func uploadImage(images: [Data]) -> Single<[String]> {
        return request(.uploadImage(images: images))
            .filterSuccessfulStatusCodes()
            .map([String].self)
    }

    func bugReport(req: BugRequestParams) -> Completable {
        return request(.bugReport(req: req))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }

}
