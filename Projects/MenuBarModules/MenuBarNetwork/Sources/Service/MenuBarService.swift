import Foundation
import Moya

public final class MenuBarService {
    public static let shared = MenuBarService()

    private let provider: MoyaProvider<MenuBarAPI>

    private init() {
        let loggingPlugin = MoyaLoggingPlugin()
        self.provider = MoyaProvider<MenuBarAPI>(plugins: [loggingPlugin])
    }

    public func login(accountID: String, password: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.login(accountID: accountID, password: password)) { result in
                switch result {
                case .success(let response):
                    do {
                        let tokenData = try response.map(TokenResponse.self)
                        JwtStore.shared.accessToken = tokenData.accessToken
                        JwtStore.shared.refreshToken = tokenData.refreshToken
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func refreshToken() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.refreshToken) { result in
                switch result {
                case .success(let response):
                    do {
                        let tokenData = try response.map(TokenResponse.self)
                        JwtStore.shared.accessToken = tokenData.accessToken
                        JwtStore.shared.refreshToken = tokenData.refreshToken
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
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
