import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class TimeTableCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "TimeTableCollectionViewCell"
    
    private let periodLabel = PiCKLabel(textColor: .modeBlack, font: .subTitle2)
    private let subjectImageView = UIImageView()
    private let subjectLabel = PiCKLabel(textColor: .modeBlack, font: .label1)
    
    public func setup(
        period: Int,
        image: UIImage,
        subject: String
    ) {
        self.periodLabel.text = "\(period)교시"
        self.periodLabel.changePointColor(targetString: "\(period)", color: .main500)
        self.subjectImageView.image = image
        self.subjectLabel.text = subject
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
        }
        subjectLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(subjectImageView.snp.trailing).offset(12)
        }
    }

}
