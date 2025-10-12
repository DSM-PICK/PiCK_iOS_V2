import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core

public class PiCKUnderlineButton: BaseButton {
    public var buttonTap: ControlEvent<Void> {
        return self.rx.tap
    }
    public override var isEnabled: Bool {
        didSet {
            self.attribute()
        }
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience public init(
        type: UIButton.ButtonType? = .system,
        buttonText: String? = String(),
        isEnabled: Bool? = true,
        isHidden: Bool? = false,
        height: CGFloat? = 17
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
        self.backgroundColor = .clear
        self.setTitleColor(.main500, for: .normal)
        self.titleLabel?.font = .pickFont(.subTitle3)
        self.layer.cornerRadius = 0
        self.contentHorizontalAlignment = .left

        if let titleLabel = self.titleLabel,
           let title = titleLabel.text {
            let attributedString = NSMutableAttributedString(string: title)
            attributedString.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: NSRange(location: 0, length: title.count))
            attributedString.addAttribute(.foregroundColor,
                                        value: UIColor.main500,
                                        range: NSRange(location: 0, length: title.count))
            attributedString.addAttribute(.font,
                                        value: UIFont.pickFont(.subTitle3),
                                        range: NSRange(location: 0, length: title.count))
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
}
