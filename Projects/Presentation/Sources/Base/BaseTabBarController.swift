import UIKit

import Core
import DesignSystem

public class BaseTabBarController: UITabBarController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }
    private func setupTabBar() {
        self.tabBar.tintColor = .main500
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .background
        self.delegate = self

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .gray100
        appearance.backgroundColor = .background
        self.tabBar.scrollEdgeAppearance = appearance
    }

}

extension BaseTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideTransitionAnimator(viewControllers: viewControllers)
    }
}

class SlideTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let viewControllers: [UIViewController]?

    let transitionDuration: Double = 0.3

    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let fromView = fromVC.view,
              let fromIndex = getIndex(forViewController: fromVC),
              let toVC = transitionContext.viewController(forKey: .to),
              let toView = toVC.view,
              let toIndex = getIndex(forViewController: toVC)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame

        fromFrameEnd.origin.x = toIndex > fromIndex ? -frame.width : +frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? +frame.width : -frame.width

        toView.frame = toFrameStart
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration) {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            } completion: { success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            }
        }
    }

    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let viewControllers = self.viewControllers else { return nil }
        for (index, viewController) in viewControllers.enumerated() {
            if viewController == vc { return index }
        }
        return nil
    }
}
