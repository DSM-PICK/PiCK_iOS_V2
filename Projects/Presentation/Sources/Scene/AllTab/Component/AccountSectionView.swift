import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

class AccountSectionView: BaseView {
    
    enum HelpSectionType: Int {
        case announcement
    }
    
    private let accountSectionView = PiCKSectionView(
        menuText: "계정",
        items: [
            ("마이 페이지", .myPage),
            ("로그아웃", .logout)
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
