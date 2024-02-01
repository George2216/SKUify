//
//  CompanyInformationRequestModel.swift
//  Domain
//
//  Created by George Churikov on 31.01.2024.
//

import Foundation

public struct CompanyInformationRequestModel: Encodable {
    public var userId: Int
    public var imageData: Data?
    public var parameters: CompanyInformationParameters?
    
    public init(
        userId: Int,
        imageData: Data? = nil,
        parameters: CompanyInformationParameters? = nil
    ) {
        self.userId = userId
        self.imageData = imageData
        self.parameters = parameters
    }
    
}

public struct CompanyInformationParameters: Encodable {
    
}
