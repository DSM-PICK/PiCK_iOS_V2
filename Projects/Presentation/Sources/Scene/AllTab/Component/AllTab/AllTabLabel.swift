import UIKit

import Core
import DesignSystem

public enum AllTabLabelEnum {
    case contentTitleLabel
    case contentLabel
}

public class AllTabLabel: BaseLabel {
    private var labelType: AllTabLabelEnum = .contentTitleLabel

    public init(
        type: AllTabLabelEnum,
        text: String? = nil
    ) {
        super.init(frame: .zero)
        self.labelType = type
        self.text = text
        attribute()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func attribute() {
        self.font = .body1

        switch labelType {
        case .contentTitleLabel:
            self.textColor = .gray800
        case .contentLabel:
            self.textColor = .modeBlack
        }
    }

}
