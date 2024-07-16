import Foundation

import RxSwift

import Core

public protocol MainRepository {
    func fetchMainData() -> Single<MainEntity?>
}
