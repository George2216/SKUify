//
//  COGCostOfGoodsCellViewTypes.swift
//  SKUify
//
//  Created by George Churikov on 04.04.2024.
//

import Foundation

enum COGCOfGTitledViewType {
    case textField(_ config: DefaultTextField.Config)
}

struct COGCOfGTitledViewInput {
    let title: String
    let viewType: COGCOfGTitledViewType
}

enum COGCOfGViewType {
    case titledView(_ input: COGCOfGTitledViewInput)
    case titledViewsInLine(_ inputs: [COGCOfGTitledViewInput])
    case buttons(_ configs: [DefaultButton.Config])
    case none
}

