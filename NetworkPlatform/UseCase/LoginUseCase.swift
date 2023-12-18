//
//  LoginUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 08.12.2023.
//

import Foundation
import Domain
import RxSwift
import RxExtensions

final class LoginUseCase: Domain.LoginUseCase {
    
    private let network: Domain.LoginNetwork
    private let realmUseCase: Domain.AuthorizationDataWriteUseCase
    
    init(
        network: Domain.LoginNetwork,
        realmUseCase: Domain.AuthorizationDataWriteUseCase
    ) {
        self.network = network
        self.realmUseCase = realmUseCase
    }
    
    func login(
        email: String,
        password: String
    ) -> Observable<Void> {
        return network
            .login(
                email: email,
                password: password
            )
            .flatMapLatest(weak: self) { owner, data in
                return owner.realmUseCase
                    .saveAuthorizationData(
                        data:
                            AuthorizationData(
                                accessToken: data.access,
                                refreshToken: data.refresh,
                                email: email,
                                password: password
                            )
                    )
            }
    }
    
}
