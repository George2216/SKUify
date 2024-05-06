//
//  AddMultipartFormDataInterceptor.swift
//  NetworkPlatform
//
//  Created by George Churikov on 23.01.2024.
//

import Foundation
import Domain
import Alamofire

final class AddMultipartFormDataInterceptor: Domain.Interceptor {
    private let parameters: Encodable
    private let media: [MultipartMediaModel]
    init(
        parameters: Encodable,
         media: [MultipartMediaModel] = []
    ) {
        self.parameters = parameters
        self.media = media
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        let multipartData = MultipartFormDataBuilder()
            .setParameters(parameters.toDictionary())
            .setMedia(media)
            .build()
        
        var modifiedRequest = urlRequest
        
        let headers = (modifiedRequest.allHTTPHeaderFields ?? [:])
            .merging(
                multipartData.headers,
                uniquingKeysWith: { $1 }
            )
        
        var body = (modifiedRequest.httpBody ?? Data())
        
        body.append(multipartData.body)
        
        modifiedRequest.allHTTPHeaderFields = headers
        
        modifiedRequest.httpBody = body
        
        completion(.success(modifiedRequest))
    }
    
}
