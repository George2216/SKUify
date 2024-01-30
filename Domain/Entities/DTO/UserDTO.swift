//
//  UserDTO.swift
//  Domain
//
//  Created by George Churikov on 19.01.2024.
//

import Foundation

public struct UserMainDTO: Codable {
    public let user: UserDTO
}


public struct UserDTO: Codable {
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var phone: String?
    public var avatarImage: String?
    
    public init(
        firstName: String?,
        lastName: String?,
        email: String?,
        phone: String?,
        avatarImage: String?
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.avatarImage = avatarImage
    }
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case phone = "contact_number"
        case avatarImage = "avatar_image"
    }
    
}

extension UserDTO: Equatable {
    public static func == (
        lhs: UserDTO,
        rhs: UserDTO
    ) -> Bool {
        lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.email == rhs.email &&
        lhs.phone == rhs.phone &&
        lhs.avatarImage == rhs.avatarImage
    }
    
}


public struct UserDTOTest: Codable {
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var phone: String?
    
    public init(
        firstName: String?,
        lastName: String?,
        email: String?,
        phone: String?
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

extension UserDTOTest: Equatable {
    public static func == (
        lhs: UserDTOTest,
        rhs: UserDTOTest
    ) -> Bool {
        lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.email == rhs.email &&
        lhs.phone == rhs.phone
    }
    
}

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
