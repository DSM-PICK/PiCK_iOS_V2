import Foundation
import Combine
import MenuBarNetwork

final class MealViewModel {
    enum State {
        case idle
        case loading
        case loaded(SchoolMealDTO)
        case error(Error)
    }

    @Published private(set) var state: State = .idle

    private let service: MenuBarService
    private var cancellables = Set<AnyCancellable>()

    init(service: MenuBarService = .shared) {
        self.service = service
    }

    func fetchMeal() {
        state = .loading

        Task {
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: Date())
                let mealData = try await service.fetchSchoolMeal(date: dateString)
                await MainActor.run {
                    state = .loaded(mealData)
                }
            } catch {
                await MainActor.run {
                    state = .error(error)
                }
            }
        }
    }
}
