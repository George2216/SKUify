//
//  Matchable.swift
//  SKUify
//
//  Created by George Churikov on 12.03.2024.
//

import Foundation

// Use to ignore associative values
protocol Matchable {
  static func ~= (lhs: Self, rhs: Self) -> Bool
}
