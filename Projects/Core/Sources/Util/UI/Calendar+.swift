import UIKit

public extension Calendar {
    func getDateGap(from: Date, to: Date? = Date()) -> Int {
        let fromDate = from.onlyDate
        let toDate = to?.onlyDate ?? Date()
        return self.dateComponents([.day], from: fromDate, to: toDate).day ?? 0
    }
}
