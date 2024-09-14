import UIKit

import SnapKit
import Then
import Lottie

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class OnboardingViewController: BaseViewController<OnboardingViewModel> {
    private let logoImageView = UIImageView(image: .onboardingLogo)
    private let onboardingButton = PiCKButton(buttonText: "로그인하고 PiCK 사용하기")

    public override func bind() {
        let input = OnboardingViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            clickOnboardingButton: onboardingButton.buttonTap.asObservable()
        )
        _ = viewModel.transform(input: input)
    }

    public override func addView() {
        [
            logoImageView,
            onboardingButton
        ].forEach { view.addSubview($0) }
    }

    public override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(200)
            $0.center.equalToSuperview()
        }
        onboardingButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

}
