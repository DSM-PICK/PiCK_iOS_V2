import UIKit

public extension Calendar {
    /// Calculates the number of days between two dates, ignoring time components.
    ///
    /// This method converts the provided `from` and `to` dates to their date-only representations
    /// (excluding time). If the `to` date is nil, the current date is used. It then computes the 
    /// difference in days between these dates using the calendar's date components and returns 0 
    /// if the calculation fails.
    ///
    /// - Parameters:
    ///   - from: The starting date.
    ///   - to: The ending date, or nil to use the current date.
    /// - Returns: The number of days between the provided dates, or 0 if the computation cannot be performed.
    func getDateGap(from: Date, to: Date? = Date()) -> Int {
        let fromDate = from.onlyDate
        let toDate = to?.onlyDate ?? Date()
        return self.dateComponents([.day], from: fromDate, to: toDate).day ?? 0
    }
}
