//
//  MultipartFormDataBuilder.swift
//  NetworkPlatform
//
//  Created by George Churikov on 23.01.2024.
//

import Foundation
import Domain
import Alamofire
import UIKit

import Foundation
import Domain
import Alamofire

fileprivate class MultipartBoundary {
    static let sharedBoundary = "----WebKitFormBoundaryyJ8QjDN31ZjnnhYi"
}

public class MultipartFormDataBuilder {
    
    private let lineBreak = "\r\n"

    private var media: [Domain.MultipartMediaModel]?
    private var parameters: [String: Any]?

    public init() {}
    
    public func setMedia(_ media: [Domain.MultipartMediaModel]) -> Self {
        self.media = media
        return self
    }
    
    public func setParameters(_ parameters: [String: Any]) -> Self {
        self.parameters = parameters
        return self
    }
    
    public func build() -> (
        headers: [String: String],
        body: Data
    ) {
        var headers = [String: String]()
        let boundary = MultipartBoundary.sharedBoundary
        
        var body = Data()
        
        if let parametersData = createParametersData(withParameters: parameters, boundary: boundary) {
            body.append(parametersData)
        }
        
        if let mediaData = createMediaData(withMedia: media, boundary: boundary) {
            body.append(mediaData)
        }

        body.append("--\(boundary)--\(lineBreak)")
        
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        
        return (headers: headers, body: body)
    }
   
    private func createParametersData(
        withParameters params: [String: Any]?,
        boundary: String
    ) -> Data? {
        guard let parameters = params else {
            return nil
        }
        
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value)\(lineBreak)")
        }
        
        return body
    }
    
    private func createMediaData(
        withMedia media: [Domain.MultipartMediaModel]?,
        boundary: String
    ) -> Data? {
        guard let media = media else {
            return nil
        }
        var body = Data()
        for file in media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(file.key)\"")
            if let photo = file.data {
                // If the data is empty then we do not add anything.
                guard !photo.isEmpty else { return Data() }
                
                body.append(";filename=\"\(file.filename)\"\(lineBreak)")
                body.append("Content-Type: \(file.mimeType + lineBreak + lineBreak)")
                body.append(photo)
            } else {
                // If the data is missing, it is deleted on the server using the PATCH method
                body.append(lineBreak + lineBreak)
            }
            body.append(lineBreak)
        }
        return body
    }
    
}


