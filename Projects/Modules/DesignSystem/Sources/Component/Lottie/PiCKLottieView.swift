import UIKit

import Then
import SnapKit

import Lottie

public class PiCKLottieView: UIView {
    private var lottieAnimationView: LottieAnimationView?

    public init() {
        super.init(frame: .zero)

        let animation: LottieAnimation? = AnimationAsset.pickLottie.animation

        self.lottieAnimationView = .init(animation: animation)

        self.configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        guard let lottieAnimationView else { return }
        self.addSubview(lottieAnimationView)

        lottieAnimationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public func play() {
        self.lottieAnimationView?.play()
        self.lottieAnimationView?.animationSpeed = 1.5
    }

}
