//
//  AlertManagerProtocol.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import Foundation
import UIKit

protocol AlertManagerProtocol {
    func showAlert(_ type: AlertManager.AlertType)
    func hideAlert()
    func setup(
        window: UIWindow,
        di: DIProtocol
    )
}
