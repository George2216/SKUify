//
//  MultipartMediaModel.swift
//  Domain
//
//  Created by George Churikov on 23.01.2024.
//

import Foundation

public struct MultipartMediaModel: Encodable {
    public let key: String
    public let filename: String
    public let data: Data?
    public let mimeType: String
    public init(
        key: String,
        filename: String,
        data: Data?,
        mimeType: String
    ) {
        self.key = key
        self.filename = filename
        self.data = data
        self.mimeType = mimeType
    }
    
}
