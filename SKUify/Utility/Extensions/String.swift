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
    func dateTimeToShort() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss.SSSSSS"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd/MM/yy h:mma"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            return ""
        }
    }

}

extension String {
    func toDate() -> Date? {
        guard let date = DateConvertor.shared.convertToDate(self) else {
            return nil
        }
        return date
    }
    
    
}
