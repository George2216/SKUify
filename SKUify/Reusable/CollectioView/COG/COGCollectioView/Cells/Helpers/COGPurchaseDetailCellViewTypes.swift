//
//  COGPurchaseDetailCellViewTypes.swift
//  SKUify
//
//  Created by George Churikov on 04.04.2024.
//

import Foundation

enum COGPDTitledViewType {
    case textField(_ config: DefaultTextField.Config)
    case smallSwitch(_ config: DefaultSmallSwitch.Config)
    case button(_ config: DefaultButton.Config)
}

struct COGPDTitledViewInput {
    let title: String
    let viewType: COGPDTitledViewType
}

enum COGPDViewType {
    case titledView(_ input: COGPDTitledViewInput)
}
