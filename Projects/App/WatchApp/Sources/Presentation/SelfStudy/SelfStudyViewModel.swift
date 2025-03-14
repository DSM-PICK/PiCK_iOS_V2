import Foundation

import RxSwift
import RxCocoa

import Moya

import WatchAppNetwork

class SelfStudyViewModel: ObservableObject {
    @Published var selfStudyDTO: SelfStudyTeacherDTO?
    private let watchService = WatchService()
    private let disposeBag = DisposeBag()

    func fetchSelfStudy() {
        watchService.fetchSelfStudy(date: Date().toString())
            .asObservable()
            .subscribe(onNext: { data in
                self.selfStudyDTO = data
            }).disposed(by: disposeBag)
    }

}
