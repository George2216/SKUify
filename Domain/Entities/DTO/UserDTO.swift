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
    public var companyAvatarImage: String?
    public var companyName: String?
    public var companyEmail: String?
    public var companyWebsite: String?
    public var companyPhone: String?
    public var addressOne: String?
    public var addressTwo: String?
    public var postCode: String?
    public var currency: String
    public var city: String?
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case phone = "contact_number"
        case avatarImage = "avatar_image"
        case companyAvatarImage = "company_avatar_image"
        case companyName = "company_name"
        case companyEmail = "company_email"
        case companyWebsite = "company_website"
        case companyPhone = "company_phone"
        case addressOne = "address_1"
        case addressTwo = "address_2"
        case postCode = "post_code"
        case currency
        case city = "town_city"
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
