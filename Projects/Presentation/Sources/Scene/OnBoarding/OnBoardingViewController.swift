import UIKit

import SnapKit
import Then
import Lottie

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class OnboardingViewController: BaseViewController<OnboardingViewModel> {
    
    private let onboardingButton = PiCKButton(type: .system, buttonText: "로그인하고 PiCK사용하기")
    
    public override func attribute() {
        super.attribute()
    }
    public override func bind() {
        let input = OnboardingViewModel.Input(
            onboardingButtonDidClick: onboardingButton.buttonTap.asObservable()
        )
        _ = viewModel.transform(input: input)
    }

    public override func addView() {
        [
            onboardingButton
        ].forEach { view.addSubview($0) }
    }
    
    public override func setLayout() {
        onboardingButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(47)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
