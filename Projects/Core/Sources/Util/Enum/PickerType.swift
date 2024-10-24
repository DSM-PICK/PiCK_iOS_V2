import Foundation

public enum PickerType {
    case classroom, outingStart, outingEnd, outingPeriod, earlyLeave
}

public enum PickerTimeSelectType: String, Codable {
    case time = "TIME"
    case period = "PERIOD"
}

public enum PickerTimeType {
    case period, hour, min
}
