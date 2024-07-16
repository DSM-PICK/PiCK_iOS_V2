import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Core
import Domain

class SchoolMealDataSource {
    private let provider = MoyaProvider<SchoolMealAPI>(plugins: [MoyaLoggingPlugin()])

    static let shared = SchoolMealDataSource()
    
    func fetchSchoolMeal(date: String) -> Single<Response> {
        return provider.rx.request(.fetchSchoolMeal(date: date))
            .filterSuccessfulStatusCodes()
    }
    
}
