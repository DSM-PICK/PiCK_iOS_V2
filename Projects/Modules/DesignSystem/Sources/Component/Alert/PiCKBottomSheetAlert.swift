import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public enum AlertType {
    case displayMode, viewType
}

public class PiCKBottomSheetAlert: UIViewController {
    private let disposeBag = DisposeBag()
    
    public var clickModeButton: ((Int) -> Void)?
    
    private var type: AlertType? = nil
    private var displayType: UIUserInterfaceStyle {
        if UserDefaultsManager.shared.get(forKey: .displayMode) as! Int == 2 {
            return .light
        } else {
            return .dark
        }
    }
    
    private let dismissArrowButton = PiCKImageButton(type: .system, image: .bottomArrow, imageColor: .main500)
    private let explainLabel = UILabel().then {
        $0.textColor = .modeBlack
        $0.font = .label2
    }
    private let questionLabel = UILabel().then {
        $0.textColor = .modeBlack
        $0.font = .subTitle1
    }
    private let settingTypeLabel = UILabel().then {
        $0.textColor = .modeBlack
        $0.font = .body3
    }
    private let changeModeButton = PiCKButton(type: .system, buttonText: "")
    
    public init(
        type: AlertType? = nil
    ) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        bindActions()
        layout()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
                case .viewType:
//                    self?.clickModeButton!()
                    self?.dismiss(animated: true)
                case .displayMode:
                    self?.clickModeButton!((self?.displayType.rawValue)!)
                    self?.dismiss(animated: true)
                case .none:
                    return
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

extension PiCKBottomSheetAlert {
    private func typeLayout() {
        switch type {
        case .viewType:
            self.explainLabel.text = "픽은 메인 페이지를 커스텀 할 수 있어요!"
            self.questionLabel.text = "메인에서 오늘의 급식 보기 "
            self.settingTypeLabel.text = "지금은 시간표로 설정되어 있어요"
            self.changeModeButton.setTitle("급식으로 설정하기", for: .normal)
            self.changeModeButton.snp.remakeConstraints {
                $0.top.equalTo(settingTypeLabel.snp.bottom).offset(34)
                $0.leading.trailing.equalToSuperview().inset(30)
            }
        case .displayMode:
            self.explainLabel.text = "픽은 라이트 모드 또는 다크 모드로 변경할 수 있어요"
            switch UITraitCollection.current.userInterfaceStyle {
            case .light:
                self.questionLabel.text = "픽을 다크 모드로 설정 하시겠어요?"
                self.questionLabel.changePointColor(targetString: "다크 모드", color: .main500)
                self.changeModeButton.setTitle("다크 모드로 설정하기", for: .normal)
            default:
                self.questionLabel.text = "픽을 라이트 모드로 설정 하시겠어요?"
                self.questionLabel.changePointColor(targetString: "라이트 모드", color: .main500)
                self.changeModeButton.setTitle("라이트 모드로 설정하기", for: .normal)
            }
        case .none:
            return
        }
    }
}
