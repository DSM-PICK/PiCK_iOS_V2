import Foundation
import RealmSwift
import Domain

public class SchoolMealRealmObject: Object {
    @Persisted(primaryKey: true) public var date: String
    @Persisted public var lastUpdatedAt: Date
    @Persisted public var breakfast: MealRealmObject?
    @Persisted public var lunch: MealRealmObject?
    @Persisted public var dinner: MealRealmObject?

    public convenience init(
        date: String,
        breakfast: MealRealmObject?,
        lunch: MealRealmObject?,
        dinner: MealRealmObject?
    ) {
        self.init()
        self.date = date
        self.lastUpdatedAt = Date()
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
    }
}

public class MealRealmObject: Object {
    @Persisted public var menu: List<String>
    @Persisted public var kcal: String

    public convenience init(menu: [String], kcal: String) {
        self.init()
        self.menu.append(objectsIn: menu)
        self.kcal = kcal
    }
}

extension SchoolMealRealmObject {
    public func toDomain() -> SchoolMealEntity {
        var mealBundle: [(String, MealEntityElement)] = []

        if let breakfast = breakfast {
            mealBundle.append(("조식", MealEntityElement(
                menu: Array(breakfast.menu),
                kcal: breakfast.kcal
            )))
        }

        if let lunch = lunch {
            mealBundle.append(("중식", MealEntityElement(
                menu: Array(lunch.menu),
                kcal: lunch.kcal
            )))
        }

        if let dinner = dinner {
            mealBundle.append(("석식", MealEntityElement(
                menu: Array(dinner.menu),
                kcal: dinner.kcal
            )))
        }

        return SchoolMealEntity(
            meals: SchoolMealEntityElement(mealBundle: mealBundle)
        )
    }
}

extension SchoolMealDTO {
    public func toRealmObject() -> SchoolMealRealmObject {
        let breakfast = !meals.breakfast.menu.isEmpty
            ? MealRealmObject(menu: meals.breakfast.menu, kcal: meals.breakfast.cal)
            : nil

        let lunch = !meals.lunch.menu.isEmpty
            ? MealRealmObject(menu: meals.lunch.menu, kcal: meals.lunch.cal)
            : nil

        let dinner = !meals.dinner.menu.isEmpty
            ? MealRealmObject(menu: meals.dinner.menu, kcal: meals.dinner.cal)
            : nil

        return SchoolMealRealmObject(
            date: date,
            breakfast: breakfast,
            lunch: lunch,
            dinner: dinner
        )
    }
}
