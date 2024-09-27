import UIKit

import Then
import SnapKit

import Lottie

import Core

public class PiCKLottieView: UIView {
    private var lottieAnimationView: LottieAnimationView?
    private let rawValue = UserDefaultStorage.shared.get(forKey: .displayMode) as? Int

    private var animation: LottieAnimation? {
        switch rawValue {
        case 2:
            return AnimationAsset.darkLottie.animation

        default:
            return AnimationAsset.whiteLottie.animation
        }
    }

    public init() {
        super.init(frame: .zero)

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
        self.lottieAnimationView?.animationSpeed = 3.5
        self.lottieAnimationView?.play()
    }

}
