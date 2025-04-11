import Foundation

import RxSwift
import RxCocoa

import WatchAppNetwork

class SchoolMealViewModel: ObservableObject {
    @Published var schoolMealDTO: SchoolMealDTOElement?

    private let watchService = WatchService()
    private let disposeBag = DisposeBag()

    func fetchSchoolMeal() {
        watchService.fetchSchoolMeal(date: Date().toString())
            .asObservable()
            .subscribe(onNext: { data in
                self.schoolMealDTO = data
            }).disposed(by: disposeBag)
    }

}
