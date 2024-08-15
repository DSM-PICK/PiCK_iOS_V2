import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class ClassRoomMoveApplyViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let classRoomMoveApplyUseCase: ClassroomMoveApplyUseCase

    public init(classRoomMoveApplyUseCase: ClassroomMoveApplyUseCase) {
        self.classRoomMoveApplyUseCase = classRoomMoveApplyUseCase
    }

    public struct Input {
        let floorText: Observable<Int>
        let classRoomText: Observable<String>
        let startPeriod: Observable<Int>
        let endPeriod: Observable<Int>
        let clickClassRoomMoveApply: Observable<Void>
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
            input.classRoomText,
            input.startPeriod,
            input.endPeriod
        )

        let isApplyButtonEnable = info.map { floor, classRoom, startPeriod, endPeriod -> Bool in
            !classRoom.isEmpty
        }

        input.clickClassRoomMoveApply
            .withLatestFrom(info)
            .flatMap { floor, classRoom, startPeriod, endPeriod in
                self.classRoomMoveApplyUseCase.execute(req: .init(
                    floor: floor,
                    classroomName: classRoom,
                    startPeriod: startPeriod,
                    endPeriod: endPeriod
                ))
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
                .andThen(Single.just(PiCKStep.tabIsRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isApplyButtonEnable: isApplyButtonEnable.asSignal(onErrorJustReturn: false)
        )
    }
    
}
