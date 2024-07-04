import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

open class BaseTextField: UITextField {
    
    public let disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        buttonAction()
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
        //UIButton 관련 설정을 하는 함수
    }
    
    open func layout() {
        //UIButton의 레이아웃을 설정하는 함수
    }
    
    open func buttonAction() {
        //버튼의 이벤트와 관련된 함수
    }
}
