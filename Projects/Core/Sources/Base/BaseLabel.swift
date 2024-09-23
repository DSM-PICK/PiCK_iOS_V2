import UIKit

open class BaseLabel: UILabel {
    public override init(frame: CGRect) {
        super.init(frame: frame)

        attribute()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func attribute() {
        // UILable 관련 설정을 하는 함수
    }

}
