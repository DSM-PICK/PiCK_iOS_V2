import Foundation

import RxSwift

import Core

public class NotificationSubscribeUseCase {
    let repository: NotificationRepository

    public init(repository: NotificationRepository) {
        self.repository = repository
    }

    public func execute(topic: NotificationType, isSubscribed: Bool) -> Completable {
        return repository.subscribeNotification(req: .init(
            topic: topic.rawValue,
            isSubscribed: isSubscribed
        ))
    }

}
