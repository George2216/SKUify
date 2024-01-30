//
//  UserImageRequesModel.swift
//  Domain
//
//  Created by George Churikov on 23.01.2024.
//

import Foundation

public struct UserImageRequesModel: Encodable {
    public var avatar_image: String?
    
    public init(avatarImage: String?) {
        self.avatar_image = avatarImage
    }
    
}
