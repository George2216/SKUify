//
//  StoreKitManager.swift
//  InAppPurchasesPlatform
//
//  Created by George Churikov on 03.06.2024.
//

import Foundation
import StoreKit

final class StoreKitManager {
    
    private func getProducts() async throws -> [Product] {
        try await Product.products(for: [""])
    }
    
}
