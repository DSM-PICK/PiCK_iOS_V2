import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKCalendarShadowView: BaseView {
    public override func attribute() {
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 10
        self.layer.cornerRadius = 20
        self.backgroundColor = .background
    }
}
