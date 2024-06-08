//
//  AlertManager.swift
//  SKUify
//
//  Created by George Churikov on 25.03.2024.
//

import Foundation
import UIKit

final class AlertManager: AlertManagerProtocol {
    
    private weak var baseController: UIViewController?
    
    private var di: DIProtocol?
    
    static let share: AlertManagerProtocol = AlertManager()
    
    private init() { }

    func setup(
        window: UIWindow,
        di: DIProtocol
    ) {
        self.di = di
        baseController = window.rootViewController
    }
    
    func showAlert(_ type: AlertType) {
        guard let di else { return }
        let vc = AlertFactory.makeAlertVC(type, di: di)
        baseController?.view.window?.layer.add(
            CATransition.alertTransition(),
            forKey: kCATransition
        )
        baseController?.present(vc, animated: false)
    }
    
    func hideAlert() {
        baseController?.presentedViewController?.dismiss(animated: false)
    }
        
}

// MARK: - Alert types

extension AlertManager {

    enum AlertType {
        case common(_ input: CommonAlertView.Input)
        case note(_ input: NoteAlertView.Input)
    }
    
}
