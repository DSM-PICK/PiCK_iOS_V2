import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class ClassroomMoveApplyViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let classroomMoveApplyUseCase: ClassroomMoveApplyUseCase

    public init(classRoomMoveApplyUseCase: ClassroomMoveApplyUseCase) {
        self.classroomMoveApplyUseCase = classRoomMoveApplyUseCase
    }

    public struct Input {
        let floorText: Observable<Int>
        let classroomText: Observable<String>
        let startPeriod: Observable<Int>
        let endPeriod: Observable<Int>
        let clickClassroomMoveApply: Observable<Void>
    }
    public struct Output {
        let isApplyButtonEnable: Signal<Bool>
    }

    private var floor = PublishRelay<Int>()
    private var classroomName = PublishRelay<String>()
    private var startPeriod = PublishRelay<Int>()
    private var endPeriod = PublishRelay<Int>()

    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.floorText,
            input.classroomText,
            input.startPeriod,
            input.endPeriod
        )

        let isApplyButtonEnable = info.map { floor, classRoom, startPeriod, endPeriod -> Bool in
            !classRoom.isEmpty
        }

        input.clickClassroomMoveApply
            .withLatestFrom(info)
            .flatMap { floor, classroom, startPeriod, endPeriod in
                self.classroomMoveApplyUseCase.execute(req: .init(
                    floor: floor,
                    classroomName: classroom,
                    startPeriod: startPeriod,
                    endPeriod: endPeriod
                ))
                .catch {
                    self.steps.accept(
                        PiCKStep.applyAlertIsRequired(
                            successType: .fail,
                            alertType: .classroom
                        )
                    )
                    print($0.localizedDescription)
                    return .never()
                }
                .andThen(
                    Single.just(
                        PiCKStep.applyAlertIsRequired(
                            successType: .success,
                            alertType: .classroom
                        )
                    )
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isApplyButtonEnable: isApplyButtonEnable.asSignal(onErrorJustReturn: false)
        )
    }
    
}
