import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public enum BottomAlertType {
    case homeViewType, displayMode
}

public class PiCKMainBottomSheetAlert: UIViewController {
    private let disposeBag = DisposeBag()
    private let userDefaultStorage = UserDefaultsManager.shared

    public var clickModeButton: ((Any) -> Void)?

    private var type: BottomAlertType = .homeViewType
    private var homeViewType: HomeViewType {
        let value = userDefaultStorage.get(forKey: .homeViewMode) as? HomeViewType
        return value == .timeTable ? .schoolMeal : .timeTable
    }
    private var displayType: UIUserInterfaceStyle {
        if userDefaultStorage.get(forKey: .displayMode) as? Int == 2 {
            return .light
        } else {
            return .dark
        }
    }

    private let dismissArrowButton = PiCKImageButton(image: .bottomArrow, imageColor: .main500)
    private let explainLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label2
    )
    private let questionLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .subTitle1
    )
    private let settingTypeLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .body3
    )
    private let changeModeButton = PiCKButton(type: .system)

    public init(
        type: BottomAlertType? = .homeViewType
    ) {
        self.type = type ?? .homeViewType
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        bindActions()
        layout()
        typeLayout()
    }

    private func bindActions() {
        dismissArrowButton.buttonTap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        changeModeButton.buttonTap
            .bind(onNext: { [weak self] in
                switch self?.type {
                case .homeViewType:
                    self?.clickModeButton!(self!.homeViewType.rawValue)
                    self?.dismiss(animated: true)
                case .displayMode:
                    self?.clickModeButton!(self!.displayType.rawValue)
                    self?.dismiss(animated: true)
                default:
                    self?.dismiss(animated: true)
                }
            }).disposed(by: disposeBag)
    }

    private func layout() {
        [
            dismissArrowButton,
            explainLabel,
            questionLabel,
            settingTypeLabel,
            changeModeButton
        ].forEach { view.addSubview($0) }
        
        dismissArrowButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(48)
            $0.leading.equalToSuperview().inset(30)
        }
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(30)
        }
        settingTypeLabel.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(30)
        }
        changeModeButton.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }

}

extension PiCKMainBottomSheetAlert {
    private func typeLayout() {
        switch type {
        case .homeViewType:
            self.explainLabel.text = BottomSheetTextEnum.homeViewModeExplainText.rawValue
            switch homeViewType {
            case .timeTable:
                self.questionLabel.text = BottomSheetTextEnum.timeTableSubText.rawValue
                self.settingTypeLabel.text = BottomSheetTextEnum.timeTableExpainText.rawValue
                self.changeModeButton.setTitle(BottomSheetTextEnum.timeTableButtonText.rawValue, for: .normal)
            case .schoolMeal:
                self.questionLabel.text = BottomSheetTextEnum.schoolMealSubText.rawValue
                self.settingTypeLabel.text = BottomSheetTextEnum.schoolMealExpainText.rawValue
                self.changeModeButton.setTitle(BottomSheetTextEnum.schoolMealButtonText.rawValue, for: .normal)
            }
            self.changeModeButton.snp.remakeConstraints {
                $0.top.equalTo(settingTypeLabel.snp.bottom).offset(34)
                $0.leading.trailing.equalToSuperview().inset(30)
            }
        case .displayMode:
            self.explainLabel.text = BottomSheetTextEnum.displayModeExplainText.rawValue
            switch UITraitCollection.current.userInterfaceStyle {
            case .light:
                self.questionLabel.text = BottomSheetTextEnum.lightSubExplainText.rawValue
                self.questionLabel.changePointColor(targetString: "다크 모드", color: .main500)
                self.changeModeButton.setTitle(BottomSheetTextEnum.ligthButtonext.rawValue, for: .normal)
            default:
                self.questionLabel.text = BottomSheetTextEnum.darkSubExplainText.rawValue
                self.questionLabel.changePointColor(targetString: "라이트 모드", color: .main500)
                self.changeModeButton.setTitle(BottomSheetTextEnum.darkButtonext.rawValue, for: .normal)
            }
        }
    }
    
}
