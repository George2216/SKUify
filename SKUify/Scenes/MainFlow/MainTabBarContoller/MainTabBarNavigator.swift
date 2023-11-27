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
        let firstVC = UIViewController()
        let first = makeTabBarItemController(viewController: firstVC, title: "First", imageName: "person")
        
        let secondVC = UIViewController()
        let second = makeTabBarItemController(viewController: firstVC, title: "Second", imageName: "plus")
        
        tabBarController.viewControllers = [first, second]
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    private func makeTabBarItemController(
        viewController: UIViewController,
        title: String,
        imageName: String
    ) -> UIViewController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: imageName),
            selectedImage: nil
        )
        return navigation
        
    }
    
}
