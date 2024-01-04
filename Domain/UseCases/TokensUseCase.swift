//
//  TokensUseCase.swift
//  Domain
//
//  Created by George Churikov on 15.12.2023.
//

import Foundation
import RxSwift

public protocol TokensUseCase: TokensReadUseCase, TokensWriteUseCase { }


public protocol TokensReadUseCase {
    func getTokens() -> Observable<Tokens?>
}

public protocol TokensWriteUseCase {
    func saveTokens(data: Tokens) -> Observable<Void>
    func deleteTokens() -> Observable<Void>
    func updateAccessToken(_ accessToken: String) -> Observable<Void>
    func updateRefreshToken(_ refreshToken: String) -> Observable<Void>
}
