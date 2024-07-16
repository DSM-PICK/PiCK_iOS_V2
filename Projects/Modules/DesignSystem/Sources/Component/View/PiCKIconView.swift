//import UIKit
//
//import SnapKit
//import Then
//
//import RxSwift
//import RxCocoa
//import RxGesture
//
//import Core
//
//public class PiCKIconView: BaseView {
//    
//    public var Tap: Observable<UITapGestureRecognizer> {
//        return self.rx.tapGesture().when(.recognized)
//    }
//
//    private let iconImageView = UIImageView().then {
//        $0.tintColor = .red
//    }
//    private let titleLabel = UILabel().then {
//        $0.textColor = .modeBlack
//        $0.font = .label1
//    }
//    
//    public init(
//        image: UIImage? = UIImage(),
//        title: String? = String()
//    ) {
//        super.init(frame: .zero)
//        self.iconImageView.image = image
//        self.titleLabel.text = title
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    public override func attribute() {
//        self.backgroundColor = .background
//    }
//    public override func layout() {
//        [
//            iconImageView,
//            titleLabel
//        ].forEach { self.addSubview($0) }
//        
//        self.snp.makeConstraints {
//            $0.height.equalTo(60)
//        }
//        
//        iconImageView.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.leading.equalToSuperview().inset(24)
//            $0.width.height.equalTo(28)
//        }
//        titleLabel.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.leading.equalTo(iconImageView.snp.trailing).offset(24)
//        }
//
//    }
//}
