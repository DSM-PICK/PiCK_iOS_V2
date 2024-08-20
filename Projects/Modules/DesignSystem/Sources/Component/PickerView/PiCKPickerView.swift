import UIKit

import RxSwift
import RxCocoa

import Core

public enum PickerViewType {
    case period, hour, min
}

public class PiCKPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    private var pickerViewType: PickerViewType = .period
    public var periodText = BehaviorRelay<Int>(value: 1)
    public var timeText = BehaviorRelay<Int>(value: 0)

    private let periodArray = Array(1...10)
    private let hourArray = Array(0...23)
    private let minArray = Array(0...59)

    public init(type: PickerViewType) {
        self.pickerViewType = type
        super.init(frame: .zero)
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
        switch pickerViewType {
        case .period:
            return periodArray.count
        case .hour:
            return hourArray.count
        case .min:
            return minArray.count
        }
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerViewType {
        case .period:
            return "\(periodArray[row])"
        case .hour:
            return "\(hourArray[row])"
        case .min:
            return "\(minArray[row])"
        }
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

        switch pickerViewType {
        case .period:
            label.text = "\(periodArray[row])"
        case .hour:
            label.text = "\(hourArray[row])"
        case .min:
            label.text = "\(minArray[row])"
        }

        return view
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerViewType {
        case .period:
            periodText.accept(periodArray[row])
        case .hour:
            timeText.accept(hourArray[row])
        case .min:
            timeText.accept(minArray[row])
        }
    }

}
