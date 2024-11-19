import Foundation

public struct SchoolMealEntity {
    public let meals: SchoolMealEntityElement

    public init(meals: SchoolMealEntityElement) {
        self.meals = meals
    }
}

public struct SchoolMealEntityElement {
    public let mealBundle: [(String, MealEntityElement)]

    public init(mealBundle: [(String, MealEntityElement)]) {
        self.mealBundle = mealBundle
    }
}

public struct MealEntityElement {
    public let menu: [String]
    public let kcal: String

    public init(menu: [String], kcal: String) {
        self.menu = menu
        self.kcal = kcal
    }
}
