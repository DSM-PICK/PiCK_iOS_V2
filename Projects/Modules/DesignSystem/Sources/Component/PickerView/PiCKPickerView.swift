import UIKit

import RxSwift
import RxCocoa

import Core

public protocol PiCKPickerViewDelegate: AnyObject {
    func pickerViewDidChangeValue(_ pickerView: PiCKPickerView, type: PickerTimeType, value: Int)
}

public class PiCKPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    public weak var pickerDelegate: PiCKPickerViewDelegate?
    private var pickerTimeType: PickerTimeType = .hour

    public var periodText = BehaviorRelay<Int>(value: 1)
    public var hourText = BehaviorRelay<Int>(value: 8)
    public var minText = BehaviorRelay<Int>(value: 0)

    private let currentHour: Int
    private let currentMin: Int

    private let periodArray = Array(1...10)
    private let hourArray = Array(8...20)
    private let minArray = Array(0...59)

    public init(type: PickerTimeType) {
        self.pickerTimeType = type

        let now = Calendar.current.dateComponents([.hour, .minute], from: Date())
        self.currentHour = now.hour ?? 8
        self.currentMin = now.minute ?? 0

        hourText.accept(currentHour)
        minText.accept(currentMin)

        super.init(frame: .zero)
        self.delegate = self
        self.dataSource = self

        setInitialSelectedRow()
    }

    required init?(coder: NSCoder) {
        let now = Calendar.current.dateComponents([.hour, .minute], from: Date())
        self.currentHour = now.hour ?? 8
        self.currentMin = now.minute ?? 0

        super.init(coder: coder)
    }

    private func setInitialSelectedRow() {
        switch pickerTimeType {
        case .period:
            self.selectRow(0, inComponent: 0, animated: false)
        case .hour:
            if let initialHourIndex = hourArray.firstIndex(of: currentHour) {
                self.selectRow(initialHourIndex, inComponent: 0, animated: false)
            }
        case .min:
            self.selectRow(currentMin, inComponent: 0, animated: false)
        }
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerTimeType {
        case .period:
            return periodArray.count
        case .hour:
            return hourArray.count
        case .min:
            return minArray.count
        }
    }

    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 40
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }

    public func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        label.textColor = .modeBlack
        label.font = .pickFont(.heading4)
        label.textAlignment = .center

        view.addSubview(label)

        switch pickerTimeType {
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
        switch pickerTimeType {
        case .period:
            periodText.accept(periodArray[row])
            pickerDelegate?.pickerViewDidChangeValue(self, type: .period, value: periodArray[row])

        case .hour:
            hourText.accept(hourArray[row])
            pickerDelegate?.pickerViewDidChangeValue(self, type: .hour, value: hourArray[row])

        case .min:
            minText.accept(minArray[row])
            pickerDelegate?.pickerViewDidChangeValue(self, type: .min, value: minArray[row])
        }
    }

}
