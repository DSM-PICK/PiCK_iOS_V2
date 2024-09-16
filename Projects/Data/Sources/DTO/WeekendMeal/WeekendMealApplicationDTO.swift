import Foundation

import Core
import Domain

public struct WeekendMealApplicationDTO: Decodable {
    let status: Bool
    let month: Int?
}

extension WeekendMealApplicationDTO {
    func toDomain() -> WeekendMealApplicationEntity {
        return .init(
            status: status,
            month: month
        )
    }
}
