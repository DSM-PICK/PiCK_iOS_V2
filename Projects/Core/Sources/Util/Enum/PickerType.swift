import Foundation

public enum PickerType {
    case classroom, outingStart, outingEnd, outingPeriod, earlyLeave, studentInfo
}

public enum PickerTimeSelectType: String, Codable {
    case time = "TIME"
    case period = "PERIOD"
}

public enum PickerTimeType {
    case period, hour, min, grade, `class`, number
}
