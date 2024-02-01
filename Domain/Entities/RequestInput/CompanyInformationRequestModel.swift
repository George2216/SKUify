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
    public var companyAvatarImage: String?
    public var companyName: String?
    public var companyEmail: String?
    public var companyWebsite: String?
    public var addressOne: String?
    public var addressTwo: String?
    public var postCode: String?
    public var city: String?
    
    public init(
        companyAvatarImage: String? = nil,
        companyName: String? = nil,
        companyEmail: String? = nil,
        companyWebsite: String? = nil,
        addressOne: String? = nil,
        addressTwo: String? = nil,
        postCode: String? = nil,
        city: String? = nil
    ) {
        self.companyAvatarImage = companyAvatarImage
        self.companyName = companyName
        self.companyEmail = companyEmail
        self.companyWebsite = companyWebsite
        self.addressOne = addressOne
        self.addressTwo = addressTwo
        self.postCode = postCode
        self.city = city
    }
    
    private enum CodingKeys: String, CodingKey {
        case companyAvatarImage = "company_avatar_image"
        case companyName = "company_name"
        case companyEmail = "company_email"
        case companyWebsite = "company_website"
        case addressOne = "address_1"
        case addressTwo = "address_2"
        case postCode = "post_code"
        case city = "town_city"
    }
    
}
