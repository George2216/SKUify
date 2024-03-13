//
//  SalesCollectionItem.swift
//  SKUify
//
//  Created by George Churikov on 09.02.2024.
//

import Foundation

enum ProductsCollectionItem {
    case main(_ input: ProductMainCell.Input)
    case contentCell(_ input: ProductContentCell.Input)
    case showDetail
}
