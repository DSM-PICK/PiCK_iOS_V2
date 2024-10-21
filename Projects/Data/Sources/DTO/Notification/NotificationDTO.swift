import Foundation

import Core

import Domain

public struct NotificationDTO: Decodable {
    let subscribeTopicResponse: [NotificationDTOElement]

    enum CodingKeys: String, CodingKey {
        case subscribeTopicResponse = "subscribe_topic_response"
    }
}

extension NotificationDTO {
    func toDomain() -> NotificationEntity {
        return .init(
            subscribeTopicResponse: subscribeTopicResponse.map { $0.toDomain()
            }
        )
    }

}

public struct NotificationDTOElement: Decodable {
    let topic: NotificationType
    let isSubscribed: Bool

    enum CodingKeys: String, CodingKey {
        case topic
        case isSubscribed = "is_subscribed"
    }
}

extension NotificationDTOElement {
    func toDomain() -> NotificationEntityElement {
        return .init(
            topic: topic,
            isSubscribed: isSubscribed
        )
    }

}
