import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

import Core
import DesignSystem

public class NotificationSwitchView: BaseView {
    public var switchIsOn: Bool {
        return switchButton.isOn
    }
    public var clickSwitchButton: ControlProperty<Bool> {
        return switchButton.rx.isOn
    }

    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .subTitle1
    )
    private lazy var switchButton = UISwitch().then {
        $0.onTintColor = .main500
    }

    public func setup(
        isOn: Bool
    ) {
        self.switchButton.setOn(isOn, animated: true)
    }

    public init(
        title: String
    ) {
        self.titleLabel.text = title
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layout() {
        [
            titleLabel,
            switchButton
        ].forEach { self.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        switchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }

}
