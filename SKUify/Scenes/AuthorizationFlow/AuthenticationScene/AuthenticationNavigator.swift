//
//  LoginNavigator.swift
//  SKUify
//
//  Created by George Churikov on 16.11.2023.
//

import UIKit
import Domain

protocol AuthenticationNavigatorProtocol: AnyObject {
    func toLogin()
}

final class AuthenticationNavigator: AuthenticationNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol

    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toLogin() {
        let loginVC = AuthenticationVC()

        loginVC.viewModel = AuthenticationViewModel(
            useCases: di,
            navigator: self
        )
        
        navigationController.pushViewController(loginVC, animated: true)
    }

    deinit {
        print("Deinit")
    }
    
    
}


