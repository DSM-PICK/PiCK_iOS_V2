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
        var weekendMealPeriod: String {
            guard let start, let end else { return "" }
            let startDate = start.toDate(type: .fullDate).toString(type: .monthAndDayKor)
            let endDate = end.toDate(type: .fullDate).toString(type: .monthAndDayKor)
            return "(\(startDate) ~ \(endDate))"
        }

        return .init(
            status: status,
            period: weekendMealPeriod
        )
    }
}
