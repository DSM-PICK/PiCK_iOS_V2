import Foundation

import RxSwift

import Domain

class MailRepositoryImpl: MailRepository {
    let remoteDataSource: MailDataSource

    init(remoteDataSource: MailDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func verifyEmailCode(req: VerifyEmailCodeRequestParams) -> Completable {
          return remoteDataSource.verifyEmailCode(req: req)
      }

    func mailCodeCheck(req: MailCodeCheckRequestParams) -> Completable {
        return remoteDataSource.mailCodeCheck(req: req)
    }

}
