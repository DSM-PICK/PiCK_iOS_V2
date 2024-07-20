import UIKit

import RxSwift
import RxCocoa

open class BaseStackView: UIStackView {
    public let disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
        bind()
    }
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func attribute() {
        //뷰 관련 코드를 설정하는 함수
    }
    open func bind() {
        //UI 바인딩을 설정하는 함수
    }
    open func layout() {
        //레이아웃을 설정하는 함수
    }
}
