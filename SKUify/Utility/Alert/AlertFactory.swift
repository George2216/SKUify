//
//  AlertFactory.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import Foundation
import UIKit

final class AlertFactory {
    static func makeAlertVC(
        _ type: AlertManager.AlertType,
        di: DIProtocol
    ) -> UIViewController {
        switch type {
        case .common(let input):
            return CommonAlertVC(input)
        case .note(let input):
            return NoteAlertBilder.instatiate(
                input,
                di: di
            )
        }
    }
    
}
