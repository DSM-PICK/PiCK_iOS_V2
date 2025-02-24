import Foundation

public extension Date {
    var onlyDate: Date {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: component) ?? Date()
    }

    /// Returns a formatted string representation of the date using the specified format.
    /// 
    /// The method formats the date according to the pattern provided by `type`'s raw value and applies the Korean locale ("ko_kr") and Korea Standard Time ("KST").
    /// 
    /// - Parameter type: A date format indicator whose raw value defines the desired date format.
    /// - Returns: A string containing the formatted date.
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
