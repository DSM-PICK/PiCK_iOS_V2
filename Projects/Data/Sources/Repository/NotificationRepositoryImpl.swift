import Foundation

import RxSwift

import Moya

import Domain

class NotificationRepositoryImpl: NotificationRepository {
    private let remoteDataSource: NotificationDataSource

    init(remoteDataSource: NotificationDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func subscribeNotification(req: NotificationRequestParams) -> Completable {
        return remoteDataSource.subscribeNotification(req: req)
    }

    func fetchSubscribeStatus() -> Single<NotificationEntity> {
        return remoteDataSource.fetchSubscribeStatus()
            .map(NotificationDTO.self)
            .map { $0.toDomain() }
    }

}
