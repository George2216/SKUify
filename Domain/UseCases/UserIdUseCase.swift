//
//  UserIdUseCase.swift
//  Domain
//
//  Created by George Churikov on 03.01.2024.
//

import Foundation
import RxSwift

public protocol UserIdUseCase: UserIdReadUseCase, UserIdWriteUseCase {}

public protocol UserIdReadUseCase {
    func getUserId() -> Observable<Int>
}

public protocol UserIdWriteUseCase {
    func saveUserId(userId: Int) -> Observable<Void>
    func removeUserId() -> Observable<Void>

}
