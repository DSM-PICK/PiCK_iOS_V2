import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKMainNavigationBar: BaseView {
    private let presentViewController: UIViewController
    private let userDefaultStorage = UserDefaultStorage.shared

    public var displayModeButtonTap: ControlEvent<Void> {
        return displayModeButton.buttonDidTap
    }
    public var alertButtonTap: ControlEvent<Void> {
        return alertButton.buttonDidTap
    }

    private let pickLogoImageView = UIImageView(image: .PiCKLogo).then {
        $0.contentMode = .scaleAspectFit
    }
    private let displayModeButton = PiCKImageButton(image: .displayMode, imageColor: .modeBlack)
    private let alertButton = PiCKImageButton(image: .alert, imageColor: .modeBlack)
    private lazy var rightItemStackView = UIStackView(arrangedSubviews: [
        displayModeButton
        //            alertButton
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }

    public init(
        view: UIViewController
    ) {
        self.presentViewController = view
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func attribute() {
        self.backgroundColor = .clear
    }
    public override func bind() {
        displayModeButton.buttonDidTap
            .map {
                let data = self.userDefaultStorage.get(forKey: .displayMode) as? Int
                return data
            }
            .bind { data in
                if data == 2 {
                    UserDefaultStorage.shared.set(to: 1, forKey: .displayMode)
                } else {
                    UserDefaultStorage.shared.set(to: 2, forKey: .displayMode)
                }

                let value = self.userDefaultStorage.get(forKey: .displayMode) as? Int

                UIView.transition(
                    with: self.presentViewController.tabBarController!.view,
                    duration: 0.7,
                    options: .transitionCrossDissolve
                ) {
                    self.presentViewController.tabBarController?.view.window?.overrideUserInterfaceStyle = UIUserInterfaceStyle(
                        rawValue: value ?? 0
                    ) ?? .unspecified
                }
                self.presentViewController.loadViewIfNeeded()
            }.disposed(by: disposeBag)
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
        displayModeButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
//        alertButton.snp.makeConstraints {
//            $0.size.equalTo(24)
//        }
        rightItemStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }

}
