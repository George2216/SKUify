//
//  InventoryBaseNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 15.03.2024.
//

import Foundation
import Domain

class InventoryBaseNetwork {
    func makeUrl(from paginatedModel: InventoryPaginatedModel) -> String {
        var urlString = "\(paginatedModel.path())/?roi_method=4"
            let parameters = paginatedModel.toDictionary()
            .toURLParameters()
        urlString += "&\(parameters)"
        return urlString
    }
    
}
