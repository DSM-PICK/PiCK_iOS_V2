import Foundation

import RxSwift
import RxCocoa

import Moya

import WatchAppNetwork

class TimeTableViewModel: ObservableObject {
    @Published var getPostData: [TimeTableDTOElement?]?
    private let disposeBag = DisposeBag()
    let watchService = WatchService()

    init() {
        requestPost()
    }

    func requestPost() {
        watchService.fetchTimeTable()
            .asObservable()
            .subscribe(onNext: { data in
                self.getPostData = data
            }).disposed(by: disposeBag)
    }

}
