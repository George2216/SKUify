//
//  ProductViewType.swift
//  SKUify
//
//  Created by George Churikov on 11.03.2024.
//

import Foundation

enum ProductViewType {
    case text(_ text: String)
    case button(_ config: DefaultButton.Config)
    case image(_ imageType: ProductCellImageType)
    case titledMarketplace(_ input: TitledMarketplace.Input)
    case addInfo(_ input: ProductAddInfoView.Input)
    case spacer
}

struct ProductViewInput {
    let title: String
    let viewType: ProductViewType
    
}
