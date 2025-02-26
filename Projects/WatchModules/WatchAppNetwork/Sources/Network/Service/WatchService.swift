import Foundation

import RxSwift

import RxMoya
import Moya

public class WatchService {
    private let provider = MoyaProvider<WatchAPI>(plugins: [MoyaLoggingPlugin()])

    public init() { }

    public func fetchSchoolMeal(date: String) -> Single<SchoolMealDTOElement> {
        return provider.rx.request(.fetchSchoolMeal(date: date))
            .filterSuccessfulStatusCodes()
            .map(SchoolMealDTO.self)
            .map { data in
                return data.meals
            }
            .catch {
                print($0.localizedDescription)
                return .never()
            }
    }

    public func fetchTimeTable() -> Single<[TimeTableDTOElement?]> {
        return provider.rx.request(.fetchTimeTable)
            .filterSuccessfulStatusCodes()
            .map(TimeTableDTO.self)
            .map { data in
                return data.timetables
            }
            .catch {
                print($0.localizedDescription)
                return .never()
            }
    }

    public func fetchSelfStudy(date: String) -> Single<SelfStudyTeacherDTO> {
        return provider.rx.request(.fetchSelfStudy(date: date))
            .filterSuccessfulStatusCodes()
            .map(SelfStudyTeacherDTO.self)
            .map { data in
                return data
            }
            .catch {
                print($0.localizedDescription)
                return .never()
            }
    }

}
