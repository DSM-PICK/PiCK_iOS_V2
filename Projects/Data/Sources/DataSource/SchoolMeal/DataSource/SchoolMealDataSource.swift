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

class SchoolMealDataSourceImpl: BaseDataSource<SchoolMealAPI>, SchoolMealDataSource {
    func fetchSchoolMeal(date: String) -> Single<Response> {
        return request(.fetchSchoolMeal(date: date))
            .filterSuccessfulStatusCodes()
    }
    
}
