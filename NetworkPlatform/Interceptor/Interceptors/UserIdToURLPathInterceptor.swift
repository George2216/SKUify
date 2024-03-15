//
//  UserIdToURLPathInterceptor.swift
//  NetworkPlatform
//
//  Created by George Churikov on 22.01.2024.
//

import Foundation
import Alamofire
import Domain
import RxSwift

final class UserIdToURLPathInterceptor: Domain.Interceptor {
    private let disposeBag = DisposeBag()
    
    let userIdReadUseCase: UserIdReadUseCase

    init(userIdReadUseCase: UserIdReadUseCase) {
        self.userIdReadUseCase = userIdReadUseCase
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var modifiedRequest = urlRequest
        
        userIdReadUseCase
            .getUserId()
            .take(1)
            .subscribe(onNext: { userId in
                if
                    let url = urlRequest.url,
                    let newURL = URL(string: url.absoluteString + "/\(userId)/")
                {
                    modifiedRequest.url = newURL
                }
                completion(.success(modifiedRequest))
            })
            .disposed(by: disposeBag)
    }
    
}
