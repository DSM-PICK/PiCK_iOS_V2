import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import Domain
import AppNetwork

protocol MailDataSource {
    func verifyEmailCode(req: VerifyEmailCodeRequestParams) -> Completable
}

class MailSourceImpl: BaseDataSource<MailAPI>, MailDataSource {
    func verifyEmailCode(req: VerifyEmailCodeRequestParams) -> Completable {
           return request(.verifyEmailCode(req: req))
               .filterSuccessfulStatusCodes()
               .asCompletable()
       }

}
