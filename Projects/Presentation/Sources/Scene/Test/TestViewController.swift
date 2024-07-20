import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class TestViewController: UIViewController, Stepper {
    public var steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    private let button = PiCKButton(type: .system, buttonText: "Test")
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
    }
    public override func viewDidLayoutSubviews() {
        layout()
    }
    
    private func layout() {
        [
            button
        ].forEach { view.addSubview($0) }
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }

}
