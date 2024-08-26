import UIKit

public extension String {
    func toDate(type: DateFormatIndicated) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.date(from: self) ?? Date()
    }
}
