import Foundation

public struct SchoolMealEntity {
    public let date: String
    public let meals: [SchoolMealEntityElement]

    public init(
        date: String,
        meals: [SchoolMealEntityElement]
    ) {
        self.date = date
        self.meals = meals
    }
}

public struct SchoolMealEntityElement {
//    public let mealBundle: [(Int, String, [String])]
    public let breakfast: [String]
    public let lunch: [String]
    public let dinner: [String]

//    public init(mealBundle: [(Int, String, [String])]) {
//        self.mealBundle = mealBundle
//    }
    public init(
        breakfast: [String],
        lunch: [String],
        dinner: [String]
    ) {
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
    }

}
