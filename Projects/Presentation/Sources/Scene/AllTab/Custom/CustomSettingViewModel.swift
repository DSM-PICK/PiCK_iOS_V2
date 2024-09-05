import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class CustomSettingViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let userDefaultStorage = UserDefaultsManager.shared
    private var homeViewType: HomeViewType {
        let value = userDefaultStorage.getUserDataType(forKey: .homeViewMode, type: HomeViewType.self) as? HomeViewType

        value == .timeTable ?
        tabViewText.accept(("메인페이지에서 급식 또는 시간표를 볼 수 있어요!\n현재는 시간표로 설정되어 있어요.", "급식으로 보기")) :
        tabViewText.accept(("메인페이지에서 급식 또는 시간표를 볼 수 있어요!\n현재는 급식으로 설정되어 있어요.", "시간표로 보기"))

        return value == .timeTable ? .schoolMeal : .timeTable
    }

    public init() { }

    public struct Input {
        let viewWillAppear: Observable<Void>
        let clickHomeSetting: Observable<Void>
        let clickApplyAlertSetting: Observable<Void>
    }
    public struct Output { 
        let tabViewText: Driver<(String, String)>
    }

    private let tabViewText = BehaviorRelay<(String, String)>(value: ("", ""))

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .subscribe(onNext: {
                _ = self.homeViewType
            }).disposed(by: disposeBag)

        input.clickHomeSetting
            .subscribe(onNext: {
                self.steps.accept(
                    PiCKStep.applyAlertIsRequired(
                        successType: .success,
                        alertType: .complete
                    )
                )
                self.userDefaultStorage.setUserDataType(
                    to: self.homeViewType,
                    forKey: .homeViewMode
                )
            }, onError: {_ in
                self.steps.accept(
                    PiCKStep.applyAlertIsRequired(
                        successType: .fail,
                        alertType: .complete
                    )
                )
            }).disposed(by: disposeBag)

        return Output(tabViewText: tabViewText.asDriver())
    }

}
