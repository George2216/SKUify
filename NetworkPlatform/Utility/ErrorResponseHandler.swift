//
//  ErrorResponseHandler.swift
//  NetworkPlatform
//
//  Created by George Churikov on 08.12.2023.
//

import Foundation
import Domain
import RxSwift

final class ErrorResponseHandler {
    static func handle<T: Decodable>(_ response: T) -> Observable<T> {
        if let errorResponse = response as? ErrorHandledResponseModel, let error = errorResponse.detail {
            print(error)
            let customError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])
            return Observable.error(customError)
        } else {
            return Observable.just(response)
        }
    }
}
