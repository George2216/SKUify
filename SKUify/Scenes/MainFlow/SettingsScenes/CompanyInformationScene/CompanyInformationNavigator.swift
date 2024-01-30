//
//  CompanyInformationNavigator.swift
//  SKUify
//
//  Created by George Churikov on 29.01.2024.
//

import UIKit

protocol CompanyInformationNavigatorProtocol {
    func toCompanyInformation()
}

final class CompanyInformationNavigator: CompanyInformationNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toCompanyInformation() {
        let vc = CompanyInformationVC()
        vc.viewModel = CompanyInformationViewModel(
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("Deinit")
    }
    
}

