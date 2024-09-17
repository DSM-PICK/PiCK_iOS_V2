import Foundation

import Core
import Domain

public struct WeekendMealPeriodDTO: Decodable {
    let status: Bool
    let start: String?
    let end: String?
}

extension WeekendMealPeriodDTO {
    func toDomain() -> WeekendMealPeriodEntity {
        return .init(
            status: status,
            start: start,
            end: end
        )
    }
}
