import Foundation

import Core

public struct WeekendMealPeriodEntity {
    public let status: Bool
    public let period: String

    public init(status: Bool, period: String) {
        self.status = status
        self.period = period
    }

}
