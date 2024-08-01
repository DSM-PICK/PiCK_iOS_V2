import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

class AccountSectionView: BaseView {
    
    enum HelpSectionType: Int {
        case myPage
    }
    
    private let accountSectionView = PiCKSectionView(
        menuText: "계정",
        items: [
            ("마이 페이지", .myPage, .main700),
            ("로그아웃", .logout, .error)
        ]
    )

    override func layout() {
        self.addSubview(accountSectionView)

        accountSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: HelpSectionType) -> Observable<IndexPath> {
        self.accountSectionView.getSelectedItem(index: type.rawValue)
    }

}
