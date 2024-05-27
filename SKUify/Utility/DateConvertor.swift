//
//  DateConvertor.swift
//  SKUify
//
//  Created by George Churikov on 16.04.2024.
//

import Foundation

protocol DateConvertorProtocol {
    func convertToDate(_ strDate: String) -> Date?
}

final class DateConvertor {
    
    static let shared: DateConvertorProtocol = DateConvertor()
    
    private let separatorTypes = ["/", "-"]
    
    private init() { }
    
    private func makeDateFormats() -> [String] {
        var formats: [String] = []
        separatorTypes.forEach { separator in
            formats.append("yyyy\(separator)MM\(separator)dd'T'HH:mm:ss")
            formats.append("yyyy\(separator)MM\(separator)dd'T'HH:mm:ss.SSSSSS")
            formats.append("yyyy\(separator)MM\(separator)dd HH:mm:ss")
            formats.append("yyyy\(separator)MM\(separator)dd HH:mm:ss.SSSSSS")
            formats.append("yyyy\(separator)MM\(separator)dd")
            formats.append("dd\(separator)MM\(separator)yyyy")
        }
        return formats
    }
    
}

extension DateConvertor: DateConvertorProtocol {
    
    func convertToDate(_ strDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        var convertedDate: Date?
        makeDateFormats()
            .forEach { format in
            dateFormatter.dateFormat = format
                guard dateFormatter.date(from: strDate) == nil else {
                    return convertedDate = dateFormatter.date(from: strDate)
                }
        }
        return convertedDate
    }
    
}
