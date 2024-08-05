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
    
    public override func attribute() {
        self.setTitle("선택", for: .normal)
        self.setTitleColor(.gray500, for: .normal)
        self.setTitleColor(.gray500, for: .selected)
        self.titleLabel?.font = .caption1
        self.layer.border(color: borderColor, width: 1)
        self.layer.cornerRadius = 8
        self.backgroundColor = .gray50
        self.tintColor = .clear
        self.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 40)
    }
    public override func layout() {
        self.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(43)
        }
    }

}
