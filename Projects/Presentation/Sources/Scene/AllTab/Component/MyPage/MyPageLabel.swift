import UIKit

import Core
import DesignSystem

public enum MyPageLabelEnum {
    case contentTitleLabel
    case contentLabel
}

public class MyPageLabel: UILabel {
    private var labelType: MyPageLabelEnum = .contentTitleLabel
    
    public init(
        type: MyPageLabelEnum,
        text: String? = nil
    ) {
        super.init(frame: .zero)
        self.labelType = type
        self.text = text
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.font = .body1

        switch labelType {
        case .contentTitleLabel:
            self.textColor = .gray800
        case .contentLabel:
            self.textColor = .modeBlack
        }
    }

}
