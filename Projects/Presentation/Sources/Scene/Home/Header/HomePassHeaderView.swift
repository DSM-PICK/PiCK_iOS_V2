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
        return value ?? ""
    }

    private let contentLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let button = UIButton(type: .system).then {
        $0.setTitleColor(.modeWhite, for: .normal)
        $0.titleLabel?.font = .pickFont(.button2)
        $0.backgroundColor = .main400
        $0.layer.cornerRadius = 8
    }

    private let waitingTitleLabel = PiCKLabel(
        textColor: .main500,
        font: .pickFont(.subTitle2)
    )
    private let waitingContentLabel = PiCKLabel(
        textColor: .gray500,
        font: .pickFont(.caption2)
    )
    private lazy var waitingStackView = UIStackView(arrangedSubviews: [
        waitingTitleLabel,
        waitingContentLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .center
    }

    public func setup(
        isWait: Bool,
        type: OutingType,
        outingText: String? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        classRoomText: String? = nil
    ) {
        if isWait == true {
            self.waitingTitleLabel.text = type.toExplainText
        } else {
            let timeValue: String
            let message: String

            switch type {
            case .application:
                timeValue = "\(startTime ?? "") - \(endTime ?? "")"
                message = "\(userName)님의 외출 시간은\n\(timeValue)입니다"

            case .earlyReturn:
                timeValue = startTime ?? ""
                message = "\(userName)님의 귀가 시간은\n\(timeValue)입니다"

            case .classroom:
                timeValue = "\(startTime ?? "")교시 - \(endTime ?? "")교시"
                let classroom = classRoomText ?? "정보 없음"
                message = "\(classroom) 이동 시간은\n\(timeValue)입니다"
            }

            self.contentLabel.text = message
            self.contentLabel.changePointColor(targetString: timeValue, color: .main500)
            self.button.setTitle(type.toPassText, for: .normal)
        }
        self.setupType(isWait: isWait)
    }

    public override func attribute() {
        self.backgroundColor = .gray50
    }
    public override func layout() {
        [
            contentLabel,
            button,
            waitingStackView
        ].forEach { self.addSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(72)
        }

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
        waitingStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupType(isWait: Bool) {
        self.button.isHidden = isWait
        self.contentLabel.isHidden = isWait

        self.waitingTitleLabel.isHidden = !isWait
        self.waitingContentLabel.isHidden = !isWait
    }

}
