import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class TimeSelectButton: BaseButton {
    public var buttonTap: ControlEvent<Void> {
        return self.rx.tap
    }

    public override var isSelected: Bool {
        didSet {
            self.attribute()
        }
    }

    private var borderColor: UIColor {
        isSelected ? .main500 : .clear
    }

    private let textLabel = PiCKLabel(
        text: "선택",
        textColor: .gray500,
        font: .caption1
    )

    public func setup(text: String) {
        self.textLabel.text = text
        self.textLabel.textColor = .modeBlack
        self.textLabel.textAlignment = .center
        self.textLabel.changePointColorList(targetStringList: ["부터", "까지"], color: .gray800)
    }

    public override func attribute() {
        self.layer.border(color: borderColor, width: 1)
        self.layer.cornerRadius = 8
        self.backgroundColor = .gray50
        self.tintColor = .clear
    }
    public override func layout() {
        self.addSubview(textLabel)

        self.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(43)
        }
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }

}
