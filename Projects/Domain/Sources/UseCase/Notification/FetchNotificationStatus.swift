import Foundation

import RxSwift

import Moya

public class FetchNotificationStatus {
    let repository: NotificationRepository

    public init(repository: NotificationRepository) {
        self.repository = repository
    }

    public func execute() -> Single<NotificationEntity> {
        return repository.fetchSubscribeStatus()
    }

}
