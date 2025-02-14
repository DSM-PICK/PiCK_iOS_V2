import Foundation

import RxSwift
import RxCocoa

import WatchAppNetwork

class SchoolMealViewModel: ObservableObject {
    @Published var getPostData: SchoolMealDTOElement?
    private let disposeBag = DisposeBag()
    private let watchService = WatchService()

    init() {
        requestPost()
    }

    func requestPost() {
        watchService.fetchSchoolMeal(date: "2024-11-12")
            .asObservable()
            .subscribe(onNext: { data in
                self.getPostData = data
            }).disposed(by: disposeBag)
    }

}
