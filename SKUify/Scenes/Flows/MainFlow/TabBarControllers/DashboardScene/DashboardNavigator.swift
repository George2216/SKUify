//
//  DashboardNavigator.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import UIKit
import Domain

protocol DashboardNavigatorProtocol: AnyObject {
    func toDashboard()
    func toSettings()
    func toNotifications()
}

final class DashboardNavigator: DashboardNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol

    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toDashboard() {
       let vc = DashboardVC()
        vc.viewModel = DashboardViewModel(
            useCases: di,
            navigator: self
        )
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toSettings() {
        let navigator = SettingsNavigator(
            navigationController: navigationController,
            di: di
        )
        navigator.toSettings()
    }
    
    func toNotifications() {
        let navigator = NotificationsNavigator(
            navigationController: navigationController,
            di: di
        )
        navigator.toNotifications()
    }
    
    deinit {
        print("Deinit")
    }
    
    
}



