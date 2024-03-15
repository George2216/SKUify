//
//  UserIdToParametersInterceptor.swift
//  NetworkPlatform
//
//  Created by George Churikov on 03.01.2024.
//

import Foundation
import Alamofire
import Domain
import RxSwift

final class UserIdToParametersInterceptor: Domain.Interceptor {
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
                    if let url = modifiedRequest.url,
                       var components = URLComponents(
                        url: url,
                        resolvingAgainstBaseURL: false
                       )
                    {
                        var queryItems = components.queryItems ?? []
                        queryItems.append(
                            URLQueryItem(
                                name: "debug_user_id",
                                value: "\(userId)"
                            )
                        )
                        
                        components.queryItems = queryItems
                        modifiedRequest.url = components.url
                    }
                    
                    completion(.success(modifiedRequest))
                })
                .disposed(by: disposeBag)
    }
    
}
