//
//  COGToApplyToAsinCellViewTypes.swift
//  SKUify
//
//  Created by George Churikov on 01.05.2024.
//

import Foundation

enum COGToApplyToAsinCellViewType {
    case titledSwith(_ input: COGImportStrategyCellTitledSwithInput)
    case titledViews(_ input: [COGImportStrategyCellTitledViewInput])
}

enum COGImportStrategyCellTitledSubviewType {
    case titledLabels(_ input: [COGImportStrategyCellTitledTextInput])
    case boldTitledLabels(_ input: [COGImportStrategyCellTitledTextInput])
}

struct COGImportStrategyCellTitledViewInput {
    let title: String
    let viewType: COGImportStrategyCellTitledSubviewType
}

struct COGImportStrategyCellTitledTextInput {
    let title: String
    let value: String
}

struct COGImportStrategyCellTitledSwithInput {
    let title: String
    let config: DefaultSmallSwitch.Config
}
