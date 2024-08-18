import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class BugReportViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let bugImageUploadUseCase: BugImageUploadUseCase
    private let bugReportUseCase: BugReportUseCase

    public init(steps: PublishRelay<any Step> = PublishRelay<Step>(), bugImageUploadUseCase: BugImageUploadUseCase, bugReportUseCase: BugReportUseCase) {
        self.steps = steps
        self.bugImageUploadUseCase = bugImageUploadUseCase
        self.bugReportUseCase = bugReportUseCase
    }

    public struct Input {
        let bugTitle: Observable<String>
        let bugExplain: Observable<String>
        let bugOS: Observable<String>
        let bugImages: Observable<[Data]>
        let clickBugReport: Observable<Void>
    }
    public struct Output {
        let bugImages: Driver<[String]>
    }

    private let bugImages = BehaviorRelay<[String]>(value: [])

    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.bugTitle,
            input.bugExplain,
            input.bugOS,
            input.bugImages
        )

//        let isApplyButtonEnable = info.map { title, explain, os, images -> Bool in
//
//        }

//        input.clickBugReport
//            .withLatestFrom(info)
//            .flatMap { title, explain, os, images in
//                self.bugImageUploadUseCase.execute(images: images)
//                .catch {
//                    print($0.localizedDescription)
//                    return .never()
//                }
//                .andThen(Single.just(PiCKStep.applyAlertIsRequired(successType: .success, alertType: .classRoom)))
//            }
//            .bind(to: steps)
//            .disposed(by: disposeBag)

        return Output(bugImages: bugImages.asDriver())
    }
    
}
