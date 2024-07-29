import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class HomeViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public init() {}
    
    public struct Input {
        let viewWillApper: Observable<Void>
        let clickAlert: Observable<Void>
        let clickViewMore: Observable<Void>
    }
    public struct Output {
        let viewMode: Signal<HomeViewType>
    }

    private let viewModeData = PublishRelay<HomeViewType>()

    public func transform(input: Input) -> Output {
        input.viewWillApper
            .map { _ in UserDefaultsManager.shared.get(forKey: .homeViewMode)}
            .subscribe(onNext: { [weak self] data in
                self?.viewModeData.accept(data as! HomeViewType)
            }).disposed(by: disposeBag)

        input.clickAlert
            .map { PiCKStep.alertIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickViewMore
            .map { PiCKStep.noticeIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output(viewMode: viewModeData.asSignal())
    }
    
}
