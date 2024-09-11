import Foundation

import RxSwift

import Moya

public class NotificationSubscribeUseCase {
    let repository: NotificationRepository

    public init(repository: NotificationRepository) {
        self.repository = repository
    }

    public func execute(req: NotificationRequestParams) -> Completable {
        return repository.subscribeNotification(req: req)
    }

}
