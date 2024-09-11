import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

class AccountSectionView: BaseView {
    enum AccountSectionType: Int {
        case myPage
        case logOut
    }

    private let accountSectionView = PiCKSectionView(
        menuText: "계정",
        items: [
            ("마이페이지", .myPage, .main700),
            ("로그아웃", .logout, .error)
        ]
    )

    override func layout() {
        self.addSubview(accountSectionView)

        accountSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: AccountSectionType) -> Observable<IndexPath> {
        self.accountSectionView.getSelectedItem(index: type.rawValue)
    }

}
