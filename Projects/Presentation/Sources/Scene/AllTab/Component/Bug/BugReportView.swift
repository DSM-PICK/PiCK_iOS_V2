import UIKit

import Core
import DesignSystem

public enum BugType {
    case location
    case explain
    case photo
}

public class BugReportView: BaseView {
    private var bugType: BugType = .location

    private let titleLabel = PiCKLabel(text: "fjslkjfs", textColor: .modeBlack, font: .label1)
    private let textField = PiCKTextField(placeholder: "예: 메인, 외출 신청")
    private let textView = PiCKTextView(placeholder: "자세히 입력해주세요")

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
            textView
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
            $0.top.equalTo(textField.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(120)
        }
    }

    private func typeSetting() {
        switch bugType {
        case .location:
            titleLabel.text = "어디서 버그가 발생했나요? *"
            textView.isHidden = true
        case .explain:
            titleLabel.text = "버그에 대해 설명해주세요. *"
            textField.isHidden = true
        case .photo:
            break
        }
    }

}
