import UIKit

import Core
import DesignSystem

public class TabBarManager: UITabBarController {
    public static let shared = TabBarManager()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }
    private func setupTabBar() {
        self.tabBar.tintColor = .main500
        self.tabBar.isTranslucent = false
        self.tabBar.standardAppearance.backgroundColor = .white
        self.tabBar.scrollEdgeAppearance?.backgroundColor = .white
    }
    
}
