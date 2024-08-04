import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKMainNavigationBar: BaseView {
    private let presentViewController: UIViewController
    private let userDefaultStorage = UserDefaultsManager.shared

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

    private let viewSettingButton = PiCKImageButton(image: .navigationSetting, imageColor: .modeBlack)
    private let displayModeButton = PiCKImageButton(image: .displayMode, imageColor: .modeBlack)
    private let alertButton = PiCKImageButton(image: .alert, imageColor: .modeBlack)
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

    public init(
        view: UIViewController,
        settingIsHidden: Bool? = true
    ){
        self.presentViewController = view
        self.viewSettingButton.isHidden = settingIsHidden ?? true
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func attribute() {
        self.backgroundColor = .clear
    }
    public override func bind() {
        viewSettingButtonTap
            .bind(onNext: { [weak self] in
                let vc = PiCKMainBottomSheetAlert(type: .homeViewType)
                
                vc.clickModeButton = { mode in
                    self?.userDefaultStorage.set(to: mode, forKey: .homeViewMode)
                }
                self?.presentViewController.presentAsCustomDents(view: vc, height: 252)
            }).disposed(by: disposeBag)

        displayModeButton.buttonTap
            .bind(onNext: { [weak self] in
                let vc = PiCKMainBottomSheetAlert(type: .displayMode)
                
                vc.clickModeButton = { data in
                    self?.userDefaultStorage.set(to: data, forKey: .displayMode)
                    let value = UserDefaultsManager.shared.get(forKey: .displayMode) as! Int
                    print(value)
    
                    UIView.transition(
                        with: self!.presentViewController.view!,
                        duration: 0.7,
                        options: .transitionCrossDissolve
                    ) {
                        self?.presentViewController.view.window?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: value) ?? .unspecified
                    }
                }
                
                self?.presentViewController.presentAsCustomDents(view: vc, height: 228)
            }).disposed(by: disposeBag)
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
