import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class HomeHeaderView: UICollectionReusableView {
    public static let identifier = "HomeHeaderView"

    private let backgroundView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    private func attribute() {
        self.backgroundColor = .background
    }

    private func layout() {
        self.addSubview(backgroundView)

        backgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(59)
        }
    }

}
