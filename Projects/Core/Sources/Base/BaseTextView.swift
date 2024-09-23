import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

open class BaseTextView: UITextView {
    public let disposeBag = DisposeBag()

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        bindActions()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }

    open func attribute() {
        // 텍스트 뷰 관련 설정을 하는 함수
    }
    open func layout() {
        // 텍스트 뷰의 레이아웃을 설정하는 함수
    }
    open func bindActions() {
        // 텍스트 뷰의 이벤트와 관련된 함수
    }
}
