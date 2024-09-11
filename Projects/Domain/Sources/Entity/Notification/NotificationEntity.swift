import Foundation

import Core

public struct NotificationEntity {
    public let subscribeTopicResponse: [NotificationEntityElement]

    public init(subscribeTopicResponse: [NotificationEntityElement]) {
        self.subscribeTopicResponse = subscribeTopicResponse
    }
}

public struct NotificationEntityElement {
    public let topic: NotificationType.RawValue
    public let isSubscribed: Bool

    public init(
        topic: NotificationType.RawValue,
        isSubscribed: Bool
    ) {
        self.topic = topic
        self.isSubscribed = isSubscribed
    }
}
