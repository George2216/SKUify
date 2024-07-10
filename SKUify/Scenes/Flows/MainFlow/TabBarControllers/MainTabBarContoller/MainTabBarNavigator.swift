//
//  MainTabBarNavigator.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import Foundation
import UIKit

protocol MainTabBarNavigatorProtocol: AnyObject {
    func toTabBar()
    func clearNavigationControllers()
}

protocol MainTabBarNavigatorSwicherProtocol: AnyObject {
    func switchToSales(with input: SalesViewModel.SetupModel)
    func switchToInventory(with input: InventoryViewModel.SetupModel)
}

final class MainTabBarNavigator: MainTabBarNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    private let tabBarController = MainTabBarController()

    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toTabBar() {
        
        let dashboardNavigation = makeNavigation(
            title: "Dashboard",
            image: .dashboardBar
        )
        let dashboardNavigator = DashboardNavigator(
            navigationController: dashboardNavigation,
            di: di, 
            mainTabBar: self
        )
        
        let salesNavigation = makeNavigation(
            title: "Sales",
            image: .salesBar
        )
        let salesNavigator = SalesNavigator(
            navigationController: salesNavigation,
            di: di
        )
        
        let expensesNavigation = makeNavigation(
            title: "Expenses",
            image: .expensesBar
        )
        let expensesNavigator = ExpensesNavigator(
            navigationController: expensesNavigation,
            di: di
        )
        
        let inventoryNavigation = makeNavigation(
            title: "Inventory",
            image: .inventoryBar
        )
        let inventoryNavigator = InventoryNavigator(
            navigationController: inventoryNavigation,
            di: di
        )
        
        tabBarController.viewControllers = [
            dashboardNavigation,
            salesNavigation,
            expensesNavigation,
            inventoryNavigation
        ]
        
        navigationController.isNavigationBarHidden = true

        dashboardNavigator.toDashboard()
        salesNavigator.toSales()
        expensesNavigator.toExpenses()
        inventoryNavigator.toInventory()
        
        navigationController.pushViewController(tabBarController, animated: true)

    }
    
    func clearNavigationControllers() {
        tabBarController.viewControllers?.forEach { vc in
            if let nav = vc as? UINavigationController {
                nav.viewControllers.removeAll()
            }
        }
    }
    
    private func makeNavigation(
        title: String,
        image: UIImage
    ) -> UINavigationController {
        let navigation = UINavigationController()
        navigation.view.backgroundColor = .background
        
        navigation.tabBarItem = UITabBarItem(
            title: title,
            image: image,
            selectedImage: nil
        )
        return navigation
    }
    
}

extension MainTabBarNavigator: MainTabBarNavigatorSwicherProtocol {
    func switchToSales(with input: SalesViewModel.SetupModel) {
        tabBarController.switchToSales(with: input)
    }
    
    func switchToInventory(with input: InventoryViewModel.SetupModel) {
        tabBarController.switchToInventory(with: input)
    }
    
}
