import UIKit

import Then
import SnapKit

import Lottie

import Core

public class PiCKLottieView: UIView {
    private var lottieAnimationView: LottieAnimationView?
    private var animation: LottieAnimation?
    private let rawValue = UserDefaultStorage.shared.get(forKey: .displayMode) as? Int

    public init() {
        super.init(frame: .zero)

//        let animation: LottieAnimation? = AnimationAsset.pickLottie.animation
        var animation: LottieAnimation? {
            switch rawValue {
            case 2:
                AnimationAsset.darkLottie.animation

            default:
                AnimationAsset.whiteLottie.animation
            }
        }

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
        self.lottieAnimationView?.animationSpeed = 3.5
    }

}
