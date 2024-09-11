import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Core
import Domain

protocol NotificationDataSource {
    func subscribeNotification(req: NotificationRequestParams) -> Completable
    func fetchSubscribeStatus() -> Single<Response>
}

class NotificationDataSourceImpl: BaseDataSource<NotificationAPI>, NotificationDataSource {
    func subscribeNotification(req: NotificationRequestParams) -> Completable {
        return request(.subscribeNotification(req: req))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }

    func fetchSubscribeStatus() -> Single<Response> {
        return request(.fetchSubscribeStatus)
            .filterSuccessfulStatusCodes()
    }

}
