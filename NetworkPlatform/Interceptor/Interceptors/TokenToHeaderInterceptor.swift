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
    private var disposeBag = DisposeBag()
    
    let authorizationDataReadUseCase: AuthorizationDataReadUseCase

    init(authorizationDataReadUseCase: AuthorizationDataReadUseCase) {
        self.authorizationDataReadUseCase = authorizationDataReadUseCase
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var modifiedRequest = urlRequest

        authorizationDataReadUseCase
            .getAuthorizationData()
            .take(1)
            .compactMap({$0?.accessToken})
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
