import Foundation
import RxSwift
import RealmSwift
import Domain

protocol SchoolMealLocalDataSource {
    func fetchSchoolMeal(date: String) -> Single<SchoolMealEntity?>
    func saveSchoolMeal(date: String, meal: SchoolMealRealmObject) -> Completable
    func isCacheExpired() -> Bool
    func getLastUpdatedDate() -> Date?
}

class SchoolMealLocalDataSourceImpl: SchoolMealLocalDataSource {
    private let realm: Realm

    init() {
        do {
            self.realm = try Realm()
            if let realmURL = self.realm.configuration.fileURL {
                print("📦 [Realm] Database location:")
                print("   \(realmURL.path)")
                print("📦 [Realm] Open in Realm Studio with:")
                print("   \(realmURL.absoluteString)")
            }
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }

    func fetchSchoolMeal(date: String) -> Single<SchoolMealEntity?> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "SchoolMealLocalDataSource", code: -1)))
                return Disposables.create()
            }

            let realmObject = self.realm.object(ofType: SchoolMealRealmObject.self, forPrimaryKey: date)

            if let realmObject = realmObject {
                single(.success(realmObject.toDomain()))
            } else {
                single(.success(nil))
            }

            return Disposables.create()
        }
    }

    func saveSchoolMeal(date: String, meal: SchoolMealRealmObject) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "SchoolMealLocalDataSource", code: -1)))
                return Disposables.create()
            }

            do {
                try self.realm.write {
                    self.realm.add(meal, update: .modified)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    func isCacheExpired() -> Bool {
        guard let lastUpdated = getLastUpdatedDate() else {
            return true
        }

        let twoWeeksInSeconds: TimeInterval = 14 * 24 * 60 * 60
        let currentDate = Date()

        return currentDate.timeIntervalSince(lastUpdated) > twoWeeksInSeconds
    }

    func getLastUpdatedDate() -> Date? {
        let allMeals = realm.objects(SchoolMealRealmObject.self)
            .sorted(byKeyPath: "lastUpdatedAt", ascending: false)

        return allMeals.first?.lastUpdatedAt
    }
}
