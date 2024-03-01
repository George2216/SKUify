//
//  UserRequestModel.swift
//  Domain
//
//  Created by George Churikov on 31.01.2024.
//

import Foundation

public struct UserRequestModel: Encodable {
    public var parameters: UserRequersParameters?
    public var userId: Int
    public var imageData: Data?
    
    public init(
        parameters: UserRequersParameters? = nil,
        userId: Int,
        imageData: Data?
    ) {
        self.parameters = parameters
        self.userId = userId
        self.imageData = imageData
    }
    
}

public struct UserRequersParameters: Encodable {
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var phone: String?
    
    public init(
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        phone: String? = nil
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
    }
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case phone = "contact_number"
    }
    
}
