import Foundation

public enum DateFormatIndicated: String {
    /// M월 d일 (E)
    case dateAndDays = "M월 d일 (E)"
    /// yyyy-MM-dd
    case fullDate = "yyyy-MM-dd"
    /// yyyy년 MM월
    case yearsAndMonthKor = "yyyy년 MM월"
    /// yyyy
    case year = "yyyy"
    /// MMMM
    case fullMonth = "MMMM"
    /// M월
    case month = "M월"
    /// d
    case day = "d"
    /// MM-dd
    case monthAndDay = "MM-dd"
    /// M월 d일
    case monthAndDayKor = "M월 d일"
    /// yyyy년 MM월 dd일
    case fullDateKor = "yyyy년 MM월 dd일"
    /// yyyy년 MM월 d일
    case fullDateKorForCalendar = "yyyy년 MM월 d일"
    /// 요일
    case dayKor = "E요일"
}
