import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class WeekendMealApplyButton: BaseButton {
    public var buttonTap: ControlEvent<Void> {
        return self.rx.tap
    }

    public override var isSelected: Bool {
        didSet {
            self.attribute()
        }
    }

    private var titleColor: UIColor {
        !isSelected ? .gray400: .white
    }
    private var bgColor: UIColor {
        !isSelected ? .gray100: .main500
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience public init(
        type: UIButton.ButtonType,
        buttonText: String,
        isSelected: Bool? = false
    ) {
        self.init(type: type)
        self.setTitle(buttonText, for: .normal)
        self.isSelected = isSelected ?? false
        self.isEnabled = !(isSelected ?? true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func attribute() {
        self.backgroundColor = bgColor
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .button2
        self.layer.cornerRadius = 4
        self.tintColor = .clear
    }
    public override func layout() {
        self.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(70)
        }
    }

}
