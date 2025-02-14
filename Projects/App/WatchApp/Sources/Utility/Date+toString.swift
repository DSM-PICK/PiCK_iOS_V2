import Foundation

extension Date {
    func toString() -> String {
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(identifier: "KST")
        return date.string(from: Date())
    }
}
