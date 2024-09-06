import UIKit

import SnapKit
import Then
import Lottie

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class OnboardingViewController: BaseViewController<OnboardingViewModel> {
    private let onboardingButton = PiCKButton(buttonText: "로그인하고 PiCK사용하기", isHidden: false)

    public override func bind() {
        let input = OnboardingViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            clickOnboardingButton: onboardingButton.buttonTap.asObservable()
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

}
