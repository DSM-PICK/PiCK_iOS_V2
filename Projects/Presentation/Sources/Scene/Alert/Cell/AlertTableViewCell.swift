import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class AlertTableViewCell: BaseTableViewCell {
    static let identifier = "AlertTableViewCell"

    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.body1)
    )
    private let daysAgoLabel = PiCKLabel(
        textColor: .gray500,
        font: .pickFont(.body2)
    )

    public func setup(
        title: String,
        daysAgo: String
    ) {
        self.titleLabel.text = title
        self.daysAgoLabel.text = daysAgo
    }

    public override func layout() {
        [
            titleLabel,
            daysAgoLabel
        ].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        daysAgoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
        }
    }

}
