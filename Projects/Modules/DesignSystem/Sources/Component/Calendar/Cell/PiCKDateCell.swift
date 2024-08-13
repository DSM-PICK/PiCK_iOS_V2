import UIKit

import SnapKit
import Then

import Core

public class PiCKDateCell: BaseCollectionViewCell<DateModel> {
    static let identifier = "DateCell"

    public let dateLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .caption1,
        alignment: .center
    )

    public func setup(
        date: String? = nil,
        textColor: UIColor? = .modeBlack
    ) {
        self.dateLabel.text = date
        self.dateLabel.textColor = textColor
    }
    public override func attribute() {
        self.backgroundColor = .background
        self.layer.cornerRadius = self.frame.width / 2
    }

    public override func layout() {
        self.addSubview(dateLabel)

        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

}

public struct DateModel {
    let date: String?
    let textColor: UIColor?

    public init(date: String?, textColor: UIColor?) {
        self.date = date
        self.textColor = textColor
    }
}
