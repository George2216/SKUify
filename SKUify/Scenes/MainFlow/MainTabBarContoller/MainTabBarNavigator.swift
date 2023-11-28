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
        
        let dashboardNavigation = UINavigationController()
        let dashboardNavigator = DashboardNavigator(
            navigationController: dashboardNavigation,
            di: di
        )
        dashboardNavigation.tabBarItem = UITabBarItem(
            title: "Dashboard",
            image: UIImage(named: "dashboard"),
            selectedImage: nil
        )
       
        dashboardNavigation.navigationBar.prefersLargeTitles = false

        let salesNavigation = UINavigationController()
        let salesNavigator = SalesNavigator(
            navigationController: salesNavigation,
            di: di
        )
        salesNavigation.tabBarItem = UITabBarItem(
            title: "Sales",
            image: UIImage(named: "sales"),
            selectedImage: nil
        )
        
        let expensesNavigation = UINavigationController()
        let expensesNavigator = ExpensesNavigator(
            navigationController: expensesNavigation,
            di: di
        )
        expensesNavigation.tabBarItem = UITabBarItem(
            title: "Expenses",
            image: UIImage(named: "expenses"),
            selectedImage: nil
        )
        
        let inventoryNavigation = UINavigationController()
        let inventoryNavigator = InventoryNavigator(
            navigationController: inventoryNavigation,
            di: di
        )
        inventoryNavigation.tabBarItem = UITabBarItem(
            title: "Inventory",
            image: UIImage(named: "inventory"),
            selectedImage: nil
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
  
  
}
