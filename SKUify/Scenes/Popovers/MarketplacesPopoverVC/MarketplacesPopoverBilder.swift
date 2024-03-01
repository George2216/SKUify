//
//  MarketplacesPopoverBilder.swift
//  SKUify
//
//  Created by George Churikov on 01.03.2024.
//

import Foundation
import UIKit
import Domain

protocol MarketplacesPopoverDelegate {
    func selectMarketplace(_ countyCode: String?)
}

final class MarketplacesPopoverBilder {
    
    static func buildRangedCalendarModule() -> UIViewController {
        let viewModel = MarketplacesPopoverViewModel()
        let vc = MarketplacesPopoverVC()
        vc.viewModel = viewModel
        return vc
    }
    
}
