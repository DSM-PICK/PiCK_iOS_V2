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
    
    private var bgColor: UIColor {
        isEnabled ? .main500 : .main100
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience public init(
        type: UIButton.ButtonType,
        buttonText: String,
        isEnabled: Bool = true
    ) {
        self.init(type: type)
        self.setTitle(buttonText, for: .normal)
        self.isEnabled = isEnabled
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func attribute() {
        self.backgroundColor = bgColor
        self.setTitleColor(.modeWhite, for: .normal)
        self.titleLabel?.font = .button1
        self.layer.cornerRadius = 8
    }

}
