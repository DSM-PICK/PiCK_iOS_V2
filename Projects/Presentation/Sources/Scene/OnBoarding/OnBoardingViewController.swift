import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import Lottie

import Core
import DesignSystem

public class OnboardingViewController: BaseViewController<OnboardingViewModel> {

    public override func attribute() {
        super.attribute()
        self.view.backgroundColor = .red
    }
}
