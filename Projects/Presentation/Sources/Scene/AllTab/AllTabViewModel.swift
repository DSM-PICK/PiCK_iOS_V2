import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class AllTabViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public init() {}
    
    public struct Input {
        let clickNoticeTab: Observable<IndexPath>
        let clickSelfStudyTab: Observable<IndexPath>
        let clickBugReportTab: Observable<IndexPath>
        let clickMyPageTab: Observable<IndexPath>
        let clickLogOutTab: Observable<Void>
    }
    public struct Output {}
    
    public func transform(input: Input) -> Output {
        input.clickNoticeTab
            .map { _ in PiCKStep.noticeIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickSelfStudyTab
            .map { _ in PiCKStep.selfStudyIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickBugReportTab
            .map { _ in PiCKStep.bugReportIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickMyPageTab
            .map { _ in PiCKStep.myPageIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickLogOutTab
            .map { _ in PiCKStep.tabIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }

}
