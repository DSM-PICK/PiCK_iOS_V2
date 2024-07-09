import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class PiCKMainBannerView: BaseView {
    
    private let bannerBackgroundImageView = UIImageView(image: .banner)
    
    private let explainLabel = UILabel().then {
        $0.text = "오늘의 자습 감독 선생님 입니다"
        $0.textColor = .gray900
        $0.font = .label2
        $0.changePointFont(targetString: "자습 감독", font: .button2)
    }
    private let secondFloorLabel = UILabel().then {
        $0.text = "2층"
        $0.textColor = .main900
        $0.font = .label2
    }
    private let thirdFloorLabel = UILabel().then {
        $0.text = "3층"
        $0.textColor = .main900
        $0.font = .label2
    }
    private let fourthFloorLabel = UILabel().then {
        $0.text = "4층"
        $0.textColor = .main900
        $0.font = .label2
    }
    private lazy var floorStackView = UIStackView(arrangedSubviews: [
        secondFloorLabel,
        thirdFloorLabel,
        fourthFloorLabel
    ]).then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    private let secondFloorTeacherLabel = UILabel().then {
        $0.text = "조영준 선생님"
        $0.textColor = .modeBlack
        $0.font = .subTitle3
    }
    private let thirdFloorTeacherLabel = UILabel().then {
        $0.text = "육기준 선생님"
        $0.textColor = .modeBlack
        $0.font = .subTitle3
    }
    private let fourthFloorTeacherLabel = UILabel().then {
        $0.text = "김희찬 선생님"
        $0.textColor = .modeBlack
        $0.font = .subTitle3
    }
    private lazy var teacherStackView = UIStackView(arrangedSubviews: [
        secondFloorTeacherLabel,
        thirdFloorTeacherLabel,
        fourthFloorTeacherLabel
    ]).then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    public override func attribute() {
        self.layer.cornerRadius = 12
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
            $0.top.equalTo(explainLabel.snp.bottom).offset(26)
            $0.leading.equalToSuperview().inset(22.5)
            $0.height.equalTo(75)
        }
        teacherStackView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(26)
            $0.leading.equalTo(floorStackView.snp.trailing).offset(16)
            $0.height.equalTo(75)
        }
    }

}
