import Foundation
import Moya
import Combine

public final class MenuBarService {
    public static let shared = MenuBarService()

    private let provider: MoyaProvider<MenuBarAPI>
    private var cancellables = Set<AnyCancellable>()

    private init() {
        let loggingPlugin = MoyaLoggingPlugin()
        self.provider = MoyaProvider<MenuBarAPI>(plugins: [loggingPlugin])
    }

    public func fetchSchoolMeal(date: String) async throws -> SchoolMealDTO {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.fetchSchoolMeal(date: date)) { result in
                switch result {
                case .success(let response):
                    do {
                        let mealData = try response.map(SchoolMealDTO.self)
                        continuation.resume(returning: mealData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
