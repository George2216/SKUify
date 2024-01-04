//
//  TokenToHeaderInterceptor.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Alamofire
import Domain
import RxSwift

class TokenToHeaderInterceptor: Domain.Interceptor {
    private let disposeBag = DisposeBag()
    
    let tokensReadUseCase: TokensReadUseCase

    init(tokensReadUseCase: TokensReadUseCase) {
        self.tokensReadUseCase = tokensReadUseCase
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var modifiedRequest = urlRequest

        tokensReadUseCase
            .getTokens()
            .take(1)
            .compactMap({ $0?.accessToken })
            .subscribe(onNext: { token in
                modifiedRequest
                    .headers
                    .add(
                        HTTPHeader(
                            name: "Authorization",
                            value: "Bearer \(token)"
                        )
                    )
                completion(.success(modifiedRequest))
            })
            .disposed(by: disposeBag)
    }
    
}
