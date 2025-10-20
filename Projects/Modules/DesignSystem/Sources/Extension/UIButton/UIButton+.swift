import UIKit
import RxSwift
import RxCocoa

public extension UIButton {
    func throttledTapDriver(
        delay: RxTimeInterval = .milliseconds(500)
    ) -> Driver<Void> {
        return self.rx.tap
            .throttle(delay, scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: .empty())
    }
}
