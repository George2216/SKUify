//
//  COGSettingsNavigator.swift
//  SKUify
//
//  Created by George Churikov on 22.04.2024.
//

import Foundation
import UIKit

protocol COGSettingsNavigatorProtocol {
    func toCOGSettings(_ input: COGSettingsInputModel)
    func toBack()
}

final class COGSettingsNavigator: COGSettingsNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toCOGSettings(_ input: COGSettingsInputModel) {
        let vc = COGVC()
        vc.viewModel = COGSettingsViewModel(
            input: input,
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toBack() {
        navigationController.popViewController(animated: true)
    }
    
    deinit {
        print("Deinit")
    }
    
}

