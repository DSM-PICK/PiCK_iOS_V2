import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKApplyTimePickerAlert: UIViewController {
    private let periodPickerView = PiCKPickerContainerView()
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layout()
    }
    private func attribute() {
        view.backgroundColor = .background
        
        view.layer.cornerRadius = 20
    }
    private func layout() {
        view.addSubview(periodPickerView)
        
        periodPickerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(204)
        }
    }
}
