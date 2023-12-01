//
//  MainTabBarNavigator.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import Foundation
import UIKit
protocol MainTabBarNavigatorProtocol {
    func toTabBar()
}

final class MainTabBarNavigator {
    private let navigationController: UINavigationController
    private let di: DIProtocol

    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toTabBar() {
        let tabBarController = MainTabBarController()
        
        let dashboardNavigation = makeNavigation(
            title: "Dashboard",
            image: .dashboard
        )
        let dashboardNavigator = DashboardNavigator(
            navigationController: dashboardNavigation,
            di: di
        )
        
        let salesNavigation = makeNavigation(
            title: "Sales",
            image: .sales
        )
        let salesNavigator = SalesNavigator(
            navigationController: salesNavigation,
            di: di
        )
        
        let expensesNavigation = makeNavigation(
            title: "Expenses",
            image: .expenses
        )
        let expensesNavigator = ExpensesNavigator(
            navigationController: expensesNavigation,
            di: di
        )
        
        let inventoryNavigation = makeNavigation(
            title: "Inventory",
            image: .inventory
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
