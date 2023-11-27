//
//  AppNavigator.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import UIKit
import Domain

final class AppNavigator: AppNavigatorProtocol {
    
    private var fakeLauncherVC: FakeLauncherViewControllerProtocol!
    
    private var navigation: UINavigationController
    private let diContainer: DIProtocol
    
    init(
        navigation: UINavigationController,
        diContainer: DIProtocol
    ) {
        let fakeLauncherVC = FakeLauncherViewController()
        fakeLauncherVC.modalPresentationStyle = .overFullScreen
        
        self.fakeLauncherVC = fakeLauncherVC
        self.diContainer = diContainer
        self.navigation = navigation
        clearViewControllers()
    }
    
    func toLoginFlow() {
        clearViewControllers()

        let navigator = AuthenticationNavigator(
            navigationController: navigation,
            di: diContainer
        )
        navigator.toLogin()
    }
    
    func toMainFlow() {
        clearViewControllers()
        let navigator = MainTabBarNavigator(
            navigationController: navigation,
            di: diContainer
        )
        navigator.toTabBar()
    }
    
    func showFakeLuncher(isShow: Bool) {
        fakeLauncherVC.startFakeLauncher(
                from: navigation,
                isShow: isShow
            )
    }
    
    private func clearViewControllers() {
        navigation.viewControllers.removeAll()
    }
    
}
