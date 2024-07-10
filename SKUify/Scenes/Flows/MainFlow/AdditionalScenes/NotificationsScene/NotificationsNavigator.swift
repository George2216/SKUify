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
    func toSales(with input: SalesViewModel.SetupModel)
    func toInventory(with input: InventoryViewModel.SetupModel)
}

final class NotificationsNavigator: NotificationsNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    private weak var mainTabBar: MainTabBarNavigatorSwicherProtocol?
 
    init(
        navigationController: UINavigationController,
        di: DIProtocol,
        mainTabBar: MainTabBarNavigatorSwicherProtocol?
    ) {
        self.navigationController = navigationController
        self.di = di
        self.mainTabBar = mainTabBar
    }
    
    func toNotifications() {
        let vc = NotificationsVC()
        vc.viewModel = NotificationsViewModel(
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toSales(with input: SalesViewModel.SetupModel) {
        mainTabBar?.switchToSales(with: input)
    }
    
    func toInventory(with input: InventoryViewModel.SetupModel) {
        mainTabBar?.switchToInventory(with: input)
    }
    
    deinit {
        print("Deinit")
    }
    
}

