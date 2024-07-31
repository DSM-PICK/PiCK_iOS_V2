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
        self.tabBar.backgroundColor = .background
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor.clear
        appearance.shadowColor = .gray100
        appearance.backgroundColor = .background
        tabBar.scrollEdgeAppearance = appearance
    }
    
}
