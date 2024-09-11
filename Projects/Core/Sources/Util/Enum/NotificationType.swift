import Foundation

public enum NotificationType: String, Codable {
    case newNotice = "NEW_NOTICE"
    case application = "APPLICATION"
    case weekendMeal = "WEEKEND_MEAL"
    case classroom = "Classroom"
}
