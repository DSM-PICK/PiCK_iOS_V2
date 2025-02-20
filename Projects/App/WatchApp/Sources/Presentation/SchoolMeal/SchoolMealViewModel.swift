import Foundation

import RxSwift
import RxCocoa

import WatchAppNetwork

class SchoolMealViewModel: ObservableObject {
    @Published var schoolMealDTO: SchoolMealDTOElement?
    private let watchService = WatchService()
    private let disposeBag = DisposeBag()

    func requestPost() {
        watchService.fetchSchoolMeal(date: "2024-11-12")
            .asObservable()
            .subscribe(onNext: { data in
                self.schoolMealDTO = data
            }).disposed(by: disposeBag)
    }

}
