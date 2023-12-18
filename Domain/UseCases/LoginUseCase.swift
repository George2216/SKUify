//
//  LoginUseCase.swift
//  Domain
//
//  Created by George Churikov on 08.12.2023.
//

import RxSwift

public protocol LoginUseCase {
    func login(
        email: String,
        password: String
    ) -> Observable<Void>
}
