import Foundation

import Core
import Domain

public struct WeekendMealApplicationDTO: Decodable {
    let isApplicable: Bool
    let month: Int?

    enum CodingKeys: String, CodingKey {
        case isApplicable = "status"
        case month
    }
}

extension WeekendMealApplicationDTO {
    func toDomain() -> WeekendMealApplicationEntity {
        return .init(
            isApplicable: isApplicable,
            month: month
        )
    }
}
