import UIKit

public extension Date {
    var year: Int { Calendar.current.component(.year, from: self) }
    var month: Int { Calendar.current.component(.month, from: self) }
    var day: Int { Calendar.current.component(.day, from: self) }

    func isSameDay(_ otherDate: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: otherDate)
    }

    func fetchAllDatesInCurrentMonth() -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        let components = calendar.dateComponents([.year, .month], from: self)
        return range.compactMap { day -> Date? in
            return calendar.date(from: DateComponents(year: components.year, month: components.month, day: day))
        }
    }

}
