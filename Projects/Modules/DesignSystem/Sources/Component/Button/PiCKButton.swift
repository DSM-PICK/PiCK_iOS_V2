import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKButton: BaseButton {
    public var buttonTap: ControlEvent<Void> {
        return self.rx.tap
    }
    public override var isEnabled: Bool {
        didSet {
            self.attribute()
        }
    }
    private var bgColor: UIColor {
        isEnabled ? .main500 : .main100
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience public init(
        type: UIButton.ButtonType? = .system,
        buttonText: String? = String(),
        isEnabled: Bool? = true,
        isHidden: Bool? = false,
        height: CGFloat? = 47
    ) {
        self.init(type: .system)
        self.setTitle(buttonText, for: .normal)
        self.isEnabled = isEnabled ?? true
        self.isHidden = isHidden ?? false
        attribute()

        self.snp.remakeConstraints {
            $0.height.equalTo(height ?? 0)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()

        attribute()
    }

    public override func attribute() {
        self.backgroundColor = bgColor
        self.setTitleColor(.modeWhite, for: .normal)
        self.titleLabel?.font = .pickFont(.button1)
        self.layer.cornerRadius = 8
    }

}
