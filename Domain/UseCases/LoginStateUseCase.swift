//
//  LoginStateUseCase.swift
//  Domain
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import RxSwift

public protocol LoginStateUseCase: LoginStateWriteUseCase, LoginStateReadUseCase { }

public protocol LoginStateWriteUseCase {
    func login() -> Observable<Void>
    func logout() -> Observable<Void>
}

public protocol LoginStateReadUseCase {
    func isLogged() -> Observable<Bool>
}
