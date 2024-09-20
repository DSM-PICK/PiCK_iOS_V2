import Foundation

import RxSwift

import Core

public protocol HomeRepository {
    func fetchMainData() -> Single<HomeApplyStatusEntity>
}
