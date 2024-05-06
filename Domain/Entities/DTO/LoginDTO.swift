//
//  LoginDTO.swift
//  Domain
//
//  Created by George Churikov on 08.12.2023.
//

import Foundation

public struct LoginDTO: Decodable, ErrorHandledResponseModel {
    public var detail: String?
    public let access: String
    public let refresh: String
    public let user: LoginUserDataDTO

}

public struct LoginUserDataDTO: Decodable {
    public let id: Int
    public let amazonSettings: [AmazonSettingsDTO]
    public let marketplaces: [MarketplaceDTO]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case amazonSettings = "amazon_settings"
        case marketplaces
    }
}


