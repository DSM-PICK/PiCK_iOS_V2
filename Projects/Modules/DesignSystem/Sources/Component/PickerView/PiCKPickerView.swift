import UIKit

import RxSwift
import RxCocoa

import Core

public class PiCKPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    public var periodText = BehaviorRelay<Int>(value: 1)

    private let periodArray = Array(1...10)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return periodArray.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(periodArray[row])"
    }
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 40
    }
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        label.textColor = .modeBlack
        label.font = .heading4
        label.textAlignment = .center

        view.addSubview(label)

        label.text = "\(periodArray[row])"

        return view
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch selectedPickerType {
//        case .hours:
//            hourText.accept(hoursArray[row])
//        case .period:
            periodText.accept(periodArray[row])
//        default:
//            return
//        }
    }

}
