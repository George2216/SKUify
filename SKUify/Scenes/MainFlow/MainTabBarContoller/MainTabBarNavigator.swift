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
            title: "Network",
            image: UIImage(named: "Toolbox"),
            selectedImage: nil
        )
       
        let salesNavigation = UINavigationController()
        let salesNavigator = SalesNavigator(
            navigationController: salesNavigation,
            di: di
        )
        salesNavigation.tabBarItem = UITabBarItem(
            title: "Network",
            image: UIImage(named: "Toolbox"),
            selectedImage: nil
        )
        
        let expensesNavigation = UINavigationController()
        let expensesNavigator = ExpensesNavigator(
            navigationController: expensesNavigation,
            di: di
        )
        expensesNavigation.tabBarItem = UITabBarItem(
            title: "Network",
            image: UIImage(named: "Toolbox"),
            selectedImage: nil
        )
        
        let inventoryNavigation = UINavigationController()
        let inventoryNavigator = InventoryNavigator(
            navigationController: inventoryNavigation,
            di: di
        )
        inventoryNavigation.tabBarItem = UITabBarItem(
            title: "Network",
            image: UIImage(named: "Toolbox"),
            selectedImage: nil
        )
        
        
        
        tabBarController.viewControllers = [
            dashboardNavigation,
            salesNavigation,
            expensesNavigation,
            inventoryNavigation
        ]
        
        navigationController.pushViewController(tabBarController, animated: true)

        dashboardNavigator.toDashboard()
        salesNavigator.toSales()
        expensesNavigator.toExpenses()
        inventoryNavigator.toInventory()
        
    }
  
  
}
