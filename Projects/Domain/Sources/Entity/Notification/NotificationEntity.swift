import Foundation

import Core

public struct NotificationEntity {
    public let subscribeTopicResponse: [NotificationEntityElement]

    public init(subscribeTopicResponse: [NotificationEntityElement]) {
        self.subscribeTopicResponse = subscribeTopicResponse
    }
}

public struct NotificationEntityElement {
    public let topic: NotificationType
    public let isSubscribed: Bool

    public init(
        topic: NotificationType,
        isSubscribed: Bool
    ) {
        self.topic = topic
        self.isSubscribed = isSubscribed
    }
}
