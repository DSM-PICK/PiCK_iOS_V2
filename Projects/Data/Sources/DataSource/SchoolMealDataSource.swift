import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Core
import Domain

protocol SchoolMealDataSource {
    func fetchSchoolMeal(date: String) -> Single<Response>
}

class SchoolMealDataSourceImpl: SchoolMealDataSource {
    private let provider = MoyaProvider<SchoolMealAPI>(plugins: [MoyaLoggingPlugin()])

    func fetchSchoolMeal(date: String) -> Single<Response> {
        return provider.rx.request(.fetchSchoolMeal(date: date))
            .filterSuccessfulStatusCodes()
    }

}
