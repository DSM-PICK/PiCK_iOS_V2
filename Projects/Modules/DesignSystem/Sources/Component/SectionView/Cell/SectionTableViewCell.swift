import UIKit

import SnapKit
import Then

import Core

public typealias SectionType = (String, UIImage)

public class SectionTableViewCell: BaseTableViewCell {

    static let identifier = "SectionTableViewCell"

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        self.titleLabel.textColor = self.isHighlighted ? .gray600 : .modeBlack
    }

    private let sectionImageView = UIImageView()
    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label1
    )

    public func setup(
        model: SectionType
    ) {
        self.sectionImageView.image = model.1
        self.titleLabel.text = model.0
        self.selectionStyle = .none
    }

    public override func attribute() {
        contentView.backgroundColor = .background
    }
    public override func layout() {
        [
            sectionImageView,
            titleLabel
        ].forEach { contentView.addSubview($0) }

        sectionImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(sectionImageView.snp.trailing).offset(24)
        }
    }

}
