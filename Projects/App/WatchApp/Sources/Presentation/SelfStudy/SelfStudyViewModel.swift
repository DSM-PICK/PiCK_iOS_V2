import Foundation

import RxSwift
import RxCocoa

import Moya

import WatchAppNetwork

class SelfStudyViewModel: ObservableObject {
    @Published var selfStudyDTO: SelfStudyTeacherDTO?
    private let watchService = WatchService()
    private let disposeBag = DisposeBag()

    func requestPost() {
        watchService.fetchSelfStudy(date: "2025-02-07")
            .asObservable()
            .subscribe(onNext: { data in
                self.selfStudyDTO = data
            }).disposed(by: disposeBag)
    }

}
