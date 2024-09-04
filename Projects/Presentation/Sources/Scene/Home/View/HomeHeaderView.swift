import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public enum HeaderType {
    case waitOuting, waitClassRoom
    case outing, classRoom
}

public class HomeHeaderView: BaseView {
    public var buttonTap: ControlEvent<Void> {
        return button.rx.tap
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
        type: OutingType,
        outingText: String?,
        classRoomText: String?,
        waitingTitleText: String?,
        waitingContentText: String?
    ) {
//        switch type {
//        case .application:
//            waitingTitleLabel.text = waitingTitleText
//            waitingContentLabel.text = waitingContentText
//        case .earlyReturn:
//            
//        case .classroom:
//            <#code#>
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

//    private func setupType(type: OutingType) {
//        self.button.isHidden = type == .
//        self.contentLabel.isHidden = type == .waitOuting
//        self.waitingTitleLabel.isHidden = type == .outing
//        self.waitingContentLabel.isHidden = type == .outing
//    }
}
