import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import Domain
import AppNetwork

protocol MailDataSource {
    func verifyEmailCode(req: VerifyEmailCodeRequestParams) -> Completable
    func mailCodeCheck(req: MailCodeCheckRequestParams) -> Single<Bool>
}

class MailSourceImpl: BaseDataSource<MailAPI>, MailDataSource {
    func verifyEmailCode(req: VerifyEmailCodeRequestParams) -> Completable {
           return request(.verifyEmailCode(req: req))
               .filterSuccessfulStatusCodes()
               .asCompletable()
       }

    func mailCodeCheck(req: MailCodeCheckRequestParams) -> Single<Bool> {
        return request(.mailCodeCheck(req: req))
            .filterSuccessfulStatusCodes()
            .map(Bool.self)
    }
}
