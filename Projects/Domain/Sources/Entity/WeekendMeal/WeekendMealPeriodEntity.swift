import Foundation

import Core

public struct WeekendMealPeriodEntity {
    public let status: Bool
    public let start: String?
    public let end: String?

    public init(
        status: Bool,
        start: String?,
        end: String?
    ) {
        self.status = status
        self.start = start
        self.end = end
    }

}
