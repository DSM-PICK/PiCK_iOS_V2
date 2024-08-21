import Foundation

import RxSwift

import Moya

import Domain

class BugRepositoryImpl: BugRepository {
    private let remoteDataSource: BugDataSource

    init(remoteDataSource: BugDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func uploadImage(images: [Data]) -> Single<[String]> {
        return remoteDataSource.uploadImage(images: images)
    }

    func bugReport(req: BugRequestParams) -> Completable {
        return remoteDataSource.bugReport(req: req)
    }

}
