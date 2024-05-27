//
//  ExpensesResultsDTO.swift
//  Domain
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation

public struct ExpensesResultsDTO: Decodable {
    public let results: [ExpenseDTO]
    public let count: Int
    
}

public struct ExpenseDTO: Codable {
    public let id: String
    public var name: String
    public var categoryId: Int
    public var method: String
    public var interval: String
    public var startDate: String
    public var endDate: String?
    public var amount: Double
    public var vat: Double
    
    public var isOnVat: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case categoryId = "category_id"
        case method = "calculation_method"
        case interval
        case startDate = "date_start"
        case endDate = "date_end"
        case amount
        case vat = "product_vat"
    }
    
    public init(
        name: String,
        categoryId: Int,
        method: String,
        interval: String,
        startDate: String,
        endDate: String?,
        amount: Double,
        vat: Double
    ) {
        self.id = UUID().uuidString
        self.name = name
        self.categoryId = categoryId
        self.method = method
        self.interval = interval
        self.startDate = startDate
        self.endDate = endDate
        self.amount = amount
        self.vat = vat
        self.isOnVat = vat != 0.0
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        self.id = String(id)
        self.name = try container.decode(String.self, forKey: .name)
        self.categoryId = try container.decode(Int.self, forKey: .categoryId)
        self.method = try container.decode(String.self, forKey: .method)
        self.interval = try container.decode(String.self, forKey: .interval)
        self.startDate = try container.decode(String.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.vat = try container.decode(Double.self, forKey: .vat)
        self.isOnVat = vat != 0.0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Int(self.id), forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.categoryId, forKey: .categoryId)
        try container.encode(self.method, forKey: .method)
        try container.encode(self.interval, forKey: .interval)
        try container.encode(self.startDate, forKey: .startDate)
        try container.encodeIfPresent(self.endDate, forKey: .endDate)
        try container.encode(self.amount, forKey: .amount)
        try container.encode(isOnVat ? self.vat : 0.0, forKey: .vat)
    }
    
}

extension ExpenseDTO: Equatable {
    public static func == (
        lhs: ExpenseDTO,
        rhs: ExpenseDTO
    ) -> Bool {
        lhs.id == rhs.id
    }
    
}
