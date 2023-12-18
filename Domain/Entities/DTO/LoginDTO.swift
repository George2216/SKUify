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

    private enum CodingKeys: String, CodingKey {
        case access = "access"
        case refresh = "refresh"
        case detail = "detail"
    }
}
