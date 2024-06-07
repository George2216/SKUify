//
//  NotificationsNavigator.swift
//  SKUify
//
//  Created by George Churikov on 07.06.2024.
//

import Foundation
import UIKit

protocol NotificationsNavigatorProtocol {
    func toNotifications()
}

final class NotificationsNavigator: NotificationsNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toNotifications() {
        let vc = NotificationsVC()
        vc.viewModel = NotificationsViewModel(
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("Deinit")
    }
    
}

