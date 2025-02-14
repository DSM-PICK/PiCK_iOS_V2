import Foundation

import RxSwift
import RxCocoa

import Moya

import WatchAppNetwork

class SelfStudyViewModel: ObservableObject {
    @Published var getPostData: SelfStudyTeacherDTO?
    private let disposeBag = DisposeBag()

    init() {
        requestPost()
    }

    func requestPost() {
        let watchService = WatchService()

        watchService.fetchSelfStudy(date: "2025-02-07")
            .asObservable()
            .subscribe(onNext: { data in
                self.getPostData = data
            }).disposed(by: disposeBag)
    }

}
