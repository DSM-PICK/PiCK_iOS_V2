import Foundation

import RxSwift

public protocol NotificationRepository {
    func subscribeNotification(req: NotificationRequestParams) -> Completable
    func fetchSubscribeStatus() -> Single<NotificationEntity>
}
