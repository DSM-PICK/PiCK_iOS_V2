import UIKit

import RxSwift
import RxCocoa

open class BaseTableViewCell: UITableViewCell {
    private let disposeBag = DisposeBag()

    public override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        bindAction()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    open func attribute() {
        // cell 관련 설정을 하는 함수
    }
    open func bindAction() {
        // cell 관련 액션을 설정하는 함수
    }
    open func layout() {
        // cell에 서브뷰를 추가하는 함수
    }

}
