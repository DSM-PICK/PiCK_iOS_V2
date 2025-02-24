import Foundation

public extension Date {
    var onlyDate: Date {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: component) ?? Date()
    }

    func toString(type: DateFormatIndicated) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.string(from: self)
    }

    func toStringEng(type: DateFormatIndicated) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
}
