import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class AlertViewController: BaseViewController<AlertViewModel> {

    public override func attribute() {
        super.attribute()
        
        view.backgroundColor = .red
    }

}
