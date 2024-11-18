import UIKit

import SnapKit
import Then
import Lottie

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class OnboardingViewController: BaseViewController<OnboardingViewModel> {
    private let componentAppearRelay = PublishRelay<Void>()

    private var isOnLoading = false

    private let animationView = PiCKLottieView()
    private let logoImageView = UIImageView(image: .onboardingLogo)
    private let onboardingButton = PiCKButton(buttonText: "로그인하고 PiCK 사용하기")

    public override func attribute() {
        super.attribute()

        [
//            logoImageView,
            onboardingButton
        ].forEach { $0.isHidden = true }
    }

    public override func bind() {
        let input = OnboardingViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            componentAppear: componentAppearRelay.asObservable(),
            clickOnboardingButton: onboardingButton.buttonTap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.animate.asObservable()
            .map { _ in self.componentAppearRelay.accept(()) }
            .bind { [weak self] in
                guard let self else { return }
                if !isOnLoading {
//                    animationView.play()
                    isOnLoading = true
                }
            }.disposed(by: disposeBag)

        output.showComponet.asObservable()
            .bind { [weak self] in
                guard let self, isOnLoading else { return }
                UIView.transition(
                    with: self.view,
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.setComponetAppear()
                    }
                )
            }.disposed(by: disposeBag)

        output.presentAlert.asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                let alert = PiCKAlert(
                    titleText: "현재 서버가 점검중이에요",
                    explainText: "더욱 원활한 서비스 이용을 위해\n노력중이니 조금만 기다려주세요!",
                    type: .positive
                ) {
                    print("click")
                }
                owner.present(alert, animated: true)
            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
//            animationView,
            logoImageView,
            onboardingButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
//        animationView.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.size.equalTo(300)
//        }
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(240)
            $0.height.equalTo(86)
        }
        onboardingButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

    private func setComponetAppear() {
        [
//            logoImageView,
            onboardingButton
        ].forEach { $0.isHidden = false }

        animationView.isHidden = true
    }

}
