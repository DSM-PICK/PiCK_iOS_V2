import Foundation

import Core

public struct NotificationRequestParams: Encodable {
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
