//
//  SubscriptionNavigator.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import UIKit

protocol SubscriptionNavigatorProtocol {
    func toSubscritions()
}

final class SubscriptionNavigator: SubscriptionNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toSubscritions() {
        let vc = SubscriptionVC()
        vc.viewModel = SubscriptionViewModel(
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("Deinit")
    }
    
}

