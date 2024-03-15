//
//  String.swift
//  SKUify
//
//  Created by George Churikov on 08.03.2024.
//

import Foundation

// MARK: - Dates convetring

extension String {
    func dateTTimeToShort() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd/MM/yy h:mma"
            let formattedDate = dateFormatter.string(from: date)
           return formattedDate
        } else {
           return ""
        }
    }
    
}

// MARK: - Nums convertor

extension String {
    func doubleDecimalString(_ decimal: Int) -> String {
        guard let toDouble = Double(self) else {
            return ""
        }
        return toDouble.toDecimalString(decimal: decimal)
    }
    
}
