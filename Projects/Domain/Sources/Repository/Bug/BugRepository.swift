import Foundation

import RxSwift

import Moya

public protocol BugRepository {
    func uploadImage(images: [Data]) -> Single<Response>
    func bugReport(req: BugRequestParams) -> Completable
}
