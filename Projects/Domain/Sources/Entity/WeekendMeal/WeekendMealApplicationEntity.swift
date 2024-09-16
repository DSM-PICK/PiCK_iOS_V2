import Foundation

import Core

public struct WeekendMealApplicationEntity {
    public let status: Bool
    public let month: Int?

    public init(
        status: Bool,
        month: Int?
    ) {
        self.status = status
        self.month = month
    }

}
