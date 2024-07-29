import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class PiCKMainBannerView: BaseView {
    
    private let bannerBackgroundImageView = UIImageView(image: .mainBanner)
    
    private let explainLabel = PiCKLabel(
        text: "오늘의 자습 감독 선생님 입니다",
        textColor: .gray900,
        font: .label2
    ).then {
        $0.changePointFont(targetString: "자습 감독", font: .button2)
    }
    private lazy var floorStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    private lazy var teacherStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }

    public override func attribute() {
        super.attribute()

        self.layer.cornerRadius = 12
        setupBannerLabel()
    }
    
    public override func layout() {
        [
            bannerBackgroundImageView,
            explainLabel,
            floorStackView,
            teacherStackView
        ].forEach { self.addSubview($0) }
        
        bannerBackgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(27.5)
            $0.leading.equalToSuperview().inset(22.5)
        }
        floorStackView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(22.5)
            $0.height.equalTo(75)
        }
        teacherStackView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(16)
            $0.leading.equalTo(floorStackView.snp.trailing).offset(16)
            $0.height.equalTo(75)
        }
    }

    private func setupBannerLabel() {
        let floorArray = ["2층", "3층", "4층"]
        for floor in floorArray {
            let floorLabel = PiCKLabel(
                text: floor,
                textColor: .main900,
                font: .label2, 
                alignment: .center
            )
            floorStackView.addArrangedSubview(floorLabel)
        }
        
        let teacherArray = ["조영준 선생님", "박현아 선생님", "육기준 선생님"]
        for teacher in teacherArray {
            let teacherLabel = PiCKLabel(
                text: teacher,
                textColor: .modeBlack,
                font: .subTitle3
            )
            teacherStackView.addArrangedSubview(teacherLabel)
        }
    }

}
