//
//  ProfileNavigator.swift
//  SKUify
//
//  Created by George Churikov on 18.01.2024.
//

import Foundation

import UIKit

protocol ProfileNavigatorProtocol {
    func toProfile()
}

final class ProfileNavigator: ProfileNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toProfile() {
        let vc = ProfileVC()
        vc.viewModel = ProfileViewModel(
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
    
    deinit {
        print("Deinit")
    }
    
}

