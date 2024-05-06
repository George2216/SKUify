//
//  ProductCellImageType.swift
//  SKUify
//
//  Created by George Churikov on 05.03.2024.
//

import Foundation
import UIKit

enum ProductCellImageType {
    case status(_ type: StatusType)
    case shippingTo(_ type: ShippingToType)
    case fulfillment(_ type: FulfilmentType)
    
    enum StatusType: String {
        case complete
        case canceled
        case refund
        case pending
        
        init(rawValue: String) {
            let rawValue = rawValue.lowercased()
            switch rawValue {
            case Self.complete.rawValue :
                self = .complete
            case Self.canceled.rawValue:
                self = .canceled
            case Self.refund.rawValue:
                self = .refund
            case Self.pending.rawValue:
                self = .pending
            default:
                self = .canceled
            }
        }
    }
    
    enum ShippingToType {
        case marketplace(_ code: String)
        case checkLater
        
        // Input country code
        init(rawValue: String?) {
            if let rawValue {
                self = .marketplace(rawValue)
            } else {
                self = .checkLater
            }
        }
    }
    
    var image: UIImage {
        switch self {
        case .status(let type):
            switch type {
            case .complete:
                return .statusComplete
            case .canceled:
                return .statusCanceled
            case .refund:
                return .statusRefund
            case .pending:
                return .statusPending
            }
        case .shippingTo(let type):
            switch type {
            case .marketplace(let code):
                let image = UIImage(named: flagToCode(flag: code)) ?? .shippingToCheckLater
                return image
            case .checkLater:
                return .shippingToCheckLater
            }
        case .fulfillment(let type):
            switch type {
            case .fba:
                return .fulfillmentFBA
            case .fbm:
                return .fulfillmentFBM
            case .sfp:
                return .fulfillmentFBMPrime
            }
        }
    }
    
    private func flagToCode(flag: String) -> String {
        switch flag {
        case "GB", "UK":
            return "UK"
        default:
            return flag
        }
    }
    
}


extension UIImage {
    func imageWithPadding(padding: UIEdgeInsets) -> UIImage? {
        // Вычисляем новые размеры с отступами
        let newSize = CGSize(width: size.width + padding.left + padding.right,
                             height: size.height + padding.top + padding.bottom)
        
        // Создаем контекст рендеринга с новыми размерами
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        // Рисуем исходное изображение с отступами
        draw(in: CGRect(x: padding.left, y: padding.top, width: size.width, height: size.height))
        
        // Получаем изображение из контекста рендеринга
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
