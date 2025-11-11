import Foundation
import RxSwift
import RealmSwift
import Domain

protocol SchoolMealLocalDataSource {
    func fetchSchoolMeal(date: String) -> Single<SchoolMealEntity?>
    func saveSchoolMeal(date: String, meal: SchoolMealRealmObject) -> Completable
    func isCacheExpired(date: String) -> Bool
    func getLastUpdatedDate(date: String) -> Date?
}

class SchoolMealLocalDataSourceImpl: SchoolMealLocalDataSource {
    private let configuration: Realm.Configuration

    init() {
        self.configuration = Realm.Configuration.defaultConfiguration

        do {
            let realm = try Realm(configuration: self.configuration)
            if let realmURL = realm.configuration.fileURL {
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

            do {
                let realm = try Realm(configuration: self.configuration)
                let realmObject = realm.object(ofType: SchoolMealRealmObject.self, forPrimaryKey: date)

                if let realmObject = realmObject {
                    single(.success(realmObject.toDomain()))
                } else {
                    single(.success(nil))
                }
            } catch {
                single(.failure(error))
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
                let realm = try Realm(configuration: self.configuration)
                try realm.write {
                    realm.add(meal, update: .modified)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    func isCacheExpired(date: String) -> Bool {
        guard let lastUpdated = getLastUpdatedDate(date: date) else {
            return true
        }

        let twoWeeksInSeconds: TimeInterval = 14 * 24 * 60 * 60
        let currentDate = Date()

        return currentDate.timeIntervalSince(lastUpdated) > twoWeeksInSeconds
    }

    func getLastUpdatedDate(date: String) -> Date? {
        do {
            let realm = try Realm(configuration: self.configuration)
            let meal = realm.object(ofType: SchoolMealRealmObject.self, forPrimaryKey: date)
            return meal?.lastUpdatedAt
        } catch {
            print("⚠️ [Realm] Failed to get last updated date: \(error.localizedDescription)")
            return nil
        }
    }
}
