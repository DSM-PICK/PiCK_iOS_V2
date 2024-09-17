import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public enum HeaderType {
    case waitOuting, waitClassroom
    case outing, classroom
}

public class HomePassHeaderView: BaseView {
    public var buttonTap: ControlEvent<Void> {
        return button.rx.tap
    }

    private var userName: String {
        let value = UserDefaultStorage.shared.get(forKey: .userNameData) as? String
        return value ?? "Error"
    }

    private let contentLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label1
    )
    private let button = UIButton(type: .system).then {
        $0.setTitleColor(.modeWhite, for: .normal)
        $0.titleLabel?.font = .button2
        $0.backgroundColor = .main400
        $0.layer.cornerRadius = 8
    }

    private let waitingTitleLabel = PiCKLabel(
        textColor: .main500,
        font: .subTitle2
    )
    private let waitingContentLabel = PiCKLabel(
        textColor: .gray500,
        font: .caption2
    )

    public func setup(
        isWait: Bool,
        type: OutingType,
        outingText: String? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        classRoomText: String? = nil,
        waitingTitleText: String? = nil,
        waitingContentText: String? = nil
    ) {
        if isWait == true {
            
        } else {
            switch type {
            case .application:
                let timeValue = "\(startTime ?? "Error") - \(endTime ?? "Error")"

                self.contentLabel.text = "\(userName)님의 외출 시간은\n\(timeValue) 입니다"
                self.contentLabel.changePointColor(targetString: timeValue, color: .main500)

                self.button.setTitle("외출증 보기", for: .normal)
            case .earlyReturn:
                self.contentLabel.text = "\(userName)님의 귀가 시간은\n\(startTime ?? "") 입니다"
                self.contentLabel.changePointColor(targetString: startTime ?? "", color: .main500)
                self.button.setTitle("외출증 보기", for: .normal)

            case .classroom:
                let timeValue = "\(startTime ?? "Error")교시 - \(endTime ?? "Error")교시"

                self.contentLabel.text = "\(classRoomText ?? "Error") 이동 시간은\n\(timeValue) 입니다"
                self.contentLabel.changePointColor(targetString: timeValue, color: .main500)
                self.button.setTitle("돌아가기", for: .normal)
            }
        }
        self.setupType(isWait: isWait)
        //        switch type {
//        case .application:
//            waitingTitleLabel.text = waitingTitleText
//            waitingContentLabel.text = waitingContentText
//        case .earlyReturn:
//            
//        case .classroom:
//
//        }
    }

    public override func attribute() {
        self.backgroundColor = .gray50
    }
    public override func layout() {
        [
            contentLabel,
            button,
            waitingTitleLabel,
            waitingContentLabel
        ].forEach { self.addSubview($0) }

        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        button.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
    }

    private func setupType(isWait: Bool) {
        self.button.isHidden = isWait
        self.contentLabel.isHidden = isWait

        self.waitingTitleLabel.isHidden = !isWait
        self.waitingContentLabel.isHidden = !isWait
    }

}
