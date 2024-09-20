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
         return displayModeButton.buttonTap
     }
    public var alertButtonTap: ControlEvent<Void> {
         return alertButton.buttonTap
     }

    private var displayType: UIUserInterfaceStyle {
        let data = userDefaultStorage.get(forKey: .displayMode) as? Int

        return data == 2 ? .light : .dark
    }

    private let pickLogoImageView = UIImageView(image: .PiCKLogo).then {
        $0.contentMode = .scaleAspectFit
    }
    private let displayModeButton = PiCKImageButton(image: .displayMode, imageColor: .modeBlack)
    private let alertButton = PiCKImageButton(image: .alert, imageColor: .modeBlack)
    private lazy var rightItemStackView = UIStackView(
        arrangedSubviews: [
            displayModeButton,
//            alertButton
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
    }

    public init(
        view: UIViewController
    ){
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
        displayModeButton.buttonTap
            .bind { [weak self] in
                self?.userDefaultStorage.set(to: self?.displayType.rawValue, forKey: .displayMode)

                let value = self?.userDefaultStorage.get(forKey: .displayMode) as! Int

                UIView.transition(
                    with: self!.presentViewController.tabBarController!.view,
                    duration: 0.7,
                    options: .transitionCrossDissolve
                ) {
                    self?.presentViewController.tabBarController?.view.window?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: value) ?? .unspecified
                }
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
