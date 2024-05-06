//
//  COGNavigator.swift
//  SKUify
//
//  Created by George Churikov on 29.03.2024.
//

import Foundation
import UIKit

protocol COGNavigatorProtocol {
    func toCOG(_ input: COGInputModel)
    func toBack()
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
    
    func toCOG(_ input: COGInputModel) {
        let vc = COGVC()
        vc.viewModel = COGViewModel(
            input: input,
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
    
    func toBack() {
        navigationController.popViewController(animated: true)
    }
    
    deinit {
        print("Deinit")
    }
    
}

