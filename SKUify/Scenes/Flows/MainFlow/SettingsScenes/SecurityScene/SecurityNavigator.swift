//
//  SecurityNavigator.swift
//  SKUify
//
//  Created by George Churikov on 05.06.2024.
//

import Foundation
import UIKit

protocol SecurityNavigatorProtocol {
    func toSecurity()
}

final class SecurityNavigator: SecurityNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toSecurity() {
        let vc = SecurityVC()
        vc.viewModel = SecurityViewModel(
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("Deinit")
    }
    
}

