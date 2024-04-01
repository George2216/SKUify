//
//  COGNavigator.swift
//  SKUify
//
//  Created by George Churikov on 29.03.2024.
//

import Foundation
import UIKit

protocol COGNavigatorProtocol {
    func toCOG()
}

final class COGNavigator: COGNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toCOG() {
        let vc = COGVC()
        vc.viewModel = COGViewModel(
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
    
    deinit {
        print("Deinit")
    }
    
}

