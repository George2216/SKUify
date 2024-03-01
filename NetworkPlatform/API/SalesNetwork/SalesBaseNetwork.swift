//
//  SalesBaseNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 12.02.2024.
//

import Foundation
import Domain

class SalesBaseNetwork {
    func makeUrl(from paginatedModel: SalesPaginatedModel) -> String {
        var urlString = "sales/?period=all&page_name=sales&salesOnly=true&autoRefresh=true"
            let parameters = paginatedModel.toDictionary()
            .toURLParameters()
        urlString += "&\(parameters)"
        return urlString
    }
    
}
