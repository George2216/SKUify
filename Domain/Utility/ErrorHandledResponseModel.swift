//
//  ErrorHandledResponseModel.swift
//  Domain
//
//  Created by George Churikov on 08.12.2023.
//

import Foundation

public protocol ErrorHandledResponseModel where Self: Decodable {
    var detail: String? { get }
}


