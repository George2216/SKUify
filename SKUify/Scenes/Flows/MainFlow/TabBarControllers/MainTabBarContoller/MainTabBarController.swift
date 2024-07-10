//
//  MainTabBarController.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import UIKit
import RxSwift

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = 20
        tabBar.backgroundColor = .cellColor
        tabBar.itemPositioning = .centered
        tabBar.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
    }
    
    func switchToSales(with input: SalesViewModel.SetupModel) {
        let salesIndex = 1
        guard let salesNavigationController = viewControllers?[salesIndex] as? UINavigationController else { return }
        salesNavigationController.popToRootViewController(animated: false)
        guard let salesVC = salesNavigationController.topViewController as? SalesSetupProtocol else { return }
        selectedIndex = salesIndex
        salesVC.setupWith.onNext(input)
    }
    
    func switchToInventory(with input: InventoryViewModel.SetupModel) {
        let inventoryIndex = 3
        guard let inventoryNavigationController = viewControllers?[inventoryIndex] as? UINavigationController else { return }
        inventoryNavigationController.popToRootViewController(animated: false)
        guard let inventoryVC = inventoryNavigationController.topViewController as? InventorySetupProtocol else { return }
        selectedIndex = inventoryIndex
        inventoryVC.setupWith.onNext(input)
    }
 
}
