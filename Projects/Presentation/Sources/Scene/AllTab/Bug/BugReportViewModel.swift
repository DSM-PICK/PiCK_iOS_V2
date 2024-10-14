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

    public init(
        bugImageUploadUseCase: BugImageUploadUseCase,
        bugReportUseCase: BugReportUseCase
    ) {
        self.bugImageUploadUseCase = bugImageUploadUseCase
        self.bugReportUseCase = bugReportUseCase
    }

    public struct Input {
        let bugTitle: Observable<String?>
        let bugContent: Observable<String?>
        let bugImages: Observable<[Data]>
        let clickBugReport: Observable<Void>
    }
    public struct Output {
        let isReportButtonEnable: Signal<Bool>
    }

    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.bugTitle,
            input.bugContent,
            input.bugImages
        )

        let isReportButtonEnable = info.map { title, content, _ -> Bool in
            !title!.isEmpty && !content!.isEmpty
        }

        input.clickBugReport
            .withLatestFrom(info)
            .flatMap { title, content, images in
                self.bugImageUploadUseCase.execute(images: images)
                .catch {
                    print($0.localizedDescription)
                    return .just([])
                }
                .flatMap { images in
                    self.bugReportUseCase.execute(req: .init(
                        title: title ?? "",
                        content: content ?? "",
                        fileName: images
                    ))
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
                    .andThen(
                        Single.just(
                            PiCKStep.applyAlertIsRequired(
                                successType: .success,
                                alertType: .bug
                            )
                        )
                    )
                }
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isReportButtonEnable: isReportButtonEnable.asSignal(onErrorJustReturn: true)
        )
    }

}
