import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class CustomSettingViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let userDefaultStorage = UserDefaultStorage.shared
    private var homeViewType: HomeViewType {
        let value = userDefaultStorage.getUserDataType(
            forKey: .homeViewMode,
            type: HomeViewType.self
        ) as? HomeViewType

        value == .timeTable ?
        homeSettingTabViewText.accept(("메인페이지에서 급식 또는 시간표를 볼 수 있어요!\n현재는 시간표로 설정되어 있어요.", "급식으로 보기")) :
        homeSettingTabViewText.accept(("메인페이지에서 급식 또는 시간표를 볼 수 있어요!\n현재는 급식으로 설정되어 있어요.", "시간표로 보기"))

        return value == .timeTable ? .schoolMeal : .timeTable
    }

    private var pickerTimeType: PickerTimeSelectType {
        var value = userDefaultStorage.getUserDataType(
            forKey: .pickerTimeMode,
            type: PickerTimeSelectType.self
        ) as? PickerTimeSelectType

        if value == .none {
            value = .time
        }
        value == .time ?
        pickerSettingTabViewText.accept(("픽에서 신청할 때 시간 또는 교시로 설정할 수 있어요!\n현재는 시간으로 설정되어 있어요.", "교시로 설정하기")) :
        pickerSettingTabViewText.accept(("픽에서 신청할 때 시간 또는 교시로 설정할 수 있어요!\n현재는 교시로 설정되어 있어요.", "시간으로 설정하기"))

        return value == .time ? .period : .time
    }

    public init() { }

    public struct Input {
        let viewWillAppear: Observable<Void>
        let clickHomeSetting: Observable<Void>
        let clickPickerSetting: Observable<Void>
    }
    public struct Output { 
        let homeSettingTabViewText: Driver<(String, String)>
        let pickerSettingTabViewText: Driver<(String, String)>
    }

    private let homeSettingTabViewText = BehaviorRelay<(String, String)>(value: ("", ""))
    private let pickerSettingTabViewText = BehaviorRelay<(String, String)>(value: ("", ""))

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .subscribe(onNext: {
                _ = self.homeViewType
                _ = self.pickerTimeType
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

        input.clickPickerSetting
            .subscribe(onNext: {
                self.steps.accept(
                    PiCKStep.applyAlertIsRequired(
                        successType: .success,
                        alertType: .complete
                    )
                )
                self.userDefaultStorage.setUserDataType(
                    to: self.pickerTimeType,
                    forKey: .pickerTimeMode
                )
            }, onError: {_ in
                self.steps.accept(
                    PiCKStep.applyAlertIsRequired(
                        successType: .fail,
                        alertType: .complete
                    )
                )
            }).disposed(by: disposeBag)

        return Output(
            homeSettingTabViewText: homeSettingTabViewText.asDriver(),
            pickerSettingTabViewText: pickerSettingTabViewText.asDriver()
        )
    }

}
