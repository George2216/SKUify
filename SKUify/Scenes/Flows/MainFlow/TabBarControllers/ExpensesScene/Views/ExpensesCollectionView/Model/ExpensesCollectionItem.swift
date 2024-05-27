//
//  ExpensesCollectionItem.swift
//  SKUify
//
//  Created by George Churikov on 07.05.2024.
//

import Foundation

enum ExpensesCollectionItem {
    case expenses(_ input: ExpensesCell.Input)
    case buttons(_ input: ExpensesButtonsCell.Input)
}

