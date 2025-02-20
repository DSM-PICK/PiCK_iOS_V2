import Foundation

import RxSwift
import RxCocoa

import Moya

import WatchAppNetwork

class TimeTableViewModel: ObservableObject {
    @Published var timeTableDTO: [TimeTableDTOElement?]?
    private let watchService = WatchService()
    private let disposeBag = DisposeBag()

    func requestPost() {
        watchService.fetchTimeTable()
            .asObservable()
            .subscribe(onNext: { data in
                self.timeTableDTO = data
            }).disposed(by: disposeBag)
    }

}
