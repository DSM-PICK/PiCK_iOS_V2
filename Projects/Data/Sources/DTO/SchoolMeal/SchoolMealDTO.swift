import Foundation

import Domain

struct NEISMealResponse: Decodable {
    let mealServiceDietInfo: [NEISMealInfo]?
}

struct NEISMealInfo: Decodable {
    let row: [NEISMealRow]?
}

struct NEISMealRow: Decodable {
    let mealCode: String
    let mealName: String
    let mealDate: String
    let dishName: String
    let calInfo: String

    enum CodingKeys: String, CodingKey {
        case mealCode = "MMEAL_SC_CODE"
        case mealName = "MMEAL_SC_NM"
        case mealDate = "MLSV_YMD"
        case dishName = "DDISH_NM"
        case calInfo = "CAL_INFO"
    }
}

struct SchoolMealDTO: Decodable {
    let date: String
    let meals: SchoolMealDTOElement

    init(from neisResponse: NEISMealResponse, date: String) {
        self.date = date

        var breakfast = MealDTOElement(menu: [], cal: "")
        var lunch = MealDTOElement(menu: [], cal: "")
        var dinner = MealDTOElement(menu: [], cal: "")

        if let rows = neisResponse.mealServiceDietInfo?.first?.row {
            for row in rows {
                let menuItems = row.dishName
                    .replacingOccurrences(of: "<br/>", with: "\n")
                    .components(separatedBy: "\n")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }

                let calInfo = row.calInfo

                switch row.mealCode {
                case "1":
                    breakfast = MealDTOElement(menu: menuItems, cal: calInfo)
                case "2":
                    lunch = MealDTOElement(menu: menuItems, cal: calInfo)
                case "3":
                    dinner = MealDTOElement(menu: menuItems, cal: calInfo)
                default:
                    break
                }
            }
        }

        self.meals = SchoolMealDTOElement(breakfast: breakfast, lunch: lunch, dinner: dinner)
    }
}

extension SchoolMealDTO {
    func toDomain() -> SchoolMealEntity {
        return .init(meals: meals.toDomain())
    }
}

struct SchoolMealDTOElement: Decodable {
   public let breakfast, lunch, dinner: MealDTOElement
}

extension SchoolMealDTOElement {
    func toDomain() -> SchoolMealEntityElement {
        return .init(
            mealBundle: [
                ("조식", breakfast.toDomain()),
                ("중식", lunch.toDomain()),
                ("석식", dinner.toDomain())
            ]
        )
    }
}

struct MealDTOElement: Decodable {
    public let menu: [String]
    public let cal: String
}

extension MealDTOElement {
    func toDomain() -> MealEntityElement {
        return .init(
            menu: menu,
            kcal: cal
        )
    }
}
