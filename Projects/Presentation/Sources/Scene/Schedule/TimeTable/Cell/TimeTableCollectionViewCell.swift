import UIKit

import SnapKit
import Then

import Kingfisher

import Core
import Domain
import DesignSystem

public class TimeTableCollectionViewCell: BaseCollectionViewCell<TimeTableEntityElement> {
    static let identifier = "TimeTableCollectionViewCell"

    private let periodLabel = PiCKLabel(textColor: .modeBlack, font: .subTitle2)
    private let subjectImageView = UIImageView()
    private let subjectLabel = PiCKLabel(textColor: .modeBlack, font: .label1)

    public override func adapt(model: TimeTableEntityElement) {
        super.adapt(model: model)

        self.periodLabel.text = "\(model.period)교시"
        self.periodLabel.changePointColor(targetString: "\(model.period)", color: .main500)
        self.subjectImageView.kf.setImage(with: URL(string: model.subjectImage)!)
        self.subjectLabel.text = model.subjectName
    }

    public override func layout() {
        [
            periodLabel,
            subjectImageView,
            subjectLabel
        ].forEach { self.addSubview($0) }

        periodLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        subjectImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(periodLabel.snp.trailing).offset(32)
            $0.width.height.equalTo(28)
        }
        subjectLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(subjectImageView.snp.trailing).offset(12)
        }
    }

}
