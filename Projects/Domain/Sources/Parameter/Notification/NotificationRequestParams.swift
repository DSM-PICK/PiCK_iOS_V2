import Foundation

import Core

public struct NotificationRequestParams: Encodable {
    public let type: NotificationType
    public let isSubscribed: Bool

    public init(
        type: NotificationType,
        isSubscribed: Bool
    ) {
        self.type = type
        self.isSubscribed = isSubscribed
    }

}

