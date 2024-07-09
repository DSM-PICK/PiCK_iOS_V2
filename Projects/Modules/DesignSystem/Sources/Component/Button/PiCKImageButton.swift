import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKImageButton: BaseButton {
    
    public var buttonTap: ControlEvent<Void> {
        return self.rx.tap
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init(
        type: UIButton.ButtonType,
        image: UIImage,
        imageColor: UIColor
    ) {
        self.init(type: type)
        self.setImage(image, for: .normal)
        self.tintColor = imageColor
    }
}
