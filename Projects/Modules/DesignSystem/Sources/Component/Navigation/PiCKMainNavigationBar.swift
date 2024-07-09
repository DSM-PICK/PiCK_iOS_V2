import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKMainNavigationBar: BaseView {
    
    public var viewSettingButtonTap: ControlEvent<Void> {
         return viewSettingButton.buttonTap
    }
    public var displayModeButtonTap: ControlEvent<Void> {
         return displayModeButton.buttonTap
     }
    public var alertButtonTap: ControlEvent<Void> {
         return alertButton.buttonTap
     }
    
    private let pickLogoImageView = UIImageView(image: .PiCKLogo).then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let viewSettingButton = PiCKImageButton(type: .system, image: .navigationSetting, imageColor: .modeBlack)
    private let displayModeButton = PiCKImageButton(type: .system, image: .displayMode, imageColor: .modeBlack)
    private let alertButton = PiCKImageButton(type: .system, image: .alert, imageColor: .modeBlack)
    private lazy var rightItemStackView = UIStackView(
        arrangedSubviews: [
            viewSettingButton,
            displayModeButton,
            alertButton
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func attribute() {
        self.backgroundColor = .clear
    }
    
    public override func layout() {
        [
            pickLogoImageView,
            rightItemStackView
        ].forEach { self.addSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(34)
        }

        pickLogoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(48)
            $0.height.equalTo(27)
        }
        viewSettingButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        displayModeButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        alertButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        rightItemStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }

}
