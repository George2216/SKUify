//
//  AutorizationDataUseCase.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation
import RxSwift

public protocol AuthorizationDataUseCase: AuthorizationDataReadUseCase, AuthorizationDataWriteUseCase { }


public protocol AuthorizationDataReadUseCase {
    func getAuthorizationData() -> Observable<AuthorizationData?>
}

public protocol AuthorizationDataWriteUseCase {
    func saveAuthorizationData(data: AuthorizationData) -> Observable<Void>
    func delete(data: AuthorizationData) -> Observable<Void>
}
