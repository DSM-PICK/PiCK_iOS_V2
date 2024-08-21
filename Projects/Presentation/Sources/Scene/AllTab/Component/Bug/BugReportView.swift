import UIKit

import RxSwift
import RxCocoa

import Core
import DesignSystem

public enum BugType {
    case location
    case explain
    case photo
}

public class BugReportView: BaseView {
    private var bugType: BugType = .location

    public var titleText: ControlProperty<String?> {
        return textField.rx.text
    }

    public var contentText: ControlProperty<String?> {
        return textView.textViewText
    }

    private let titleLabel = PiCKLabel(textColor: .modeBlack, font: .label1)
    private let textField = PiCKTextField(placeholder: "예: 메인, 외출 신청").then {
        $0.isHidden = true
    }
    private let textView = PiCKTextView(title: "버그에 대해 설명해주세요. *", pointText: "*", placeholder: "자세히 입력해주세요").then {
        
        $0.isHidden = true
    }
    private let imageView = BugImageView().then {
        $0.isHidden = true
    }

    public init(
        type: BugType
    ) {
        self.bugType = type
        super.init(frame: .zero)
        typeSetting()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layout() {
        [
            titleLabel,
            textField,
            textView,
            imageView
        ].forEach { self.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func typeSetting() {
        switch bugType {
        case .location:
            titleLabel.text = "어디서 버그가 발생했나요? *"
            titleLabel.changePointColor(targetString: "*", color: .error)
            textField.isHidden = false
        case .explain:
            titleLabel.isHidden = true
            textView.isHidden = false
        case .photo:
            titleLabel.text = "버그 사진을 첨부해주세요"
            imageView.isHidden = false
        }
    }

}
