import Foundation

import RxSwift

import Moya

public protocol BugRepository {
    func uploadImage(images: [Data]) -> Single<[String]>
    func bugReport(req: BugRequestParams) -> Completable
}
