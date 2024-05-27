//
//  PopoverGroupedModel.swift
//  SKUify
//
//  Created by George Churikov on 23.05.2024.
//

import Foundation

struct PopoverGroupedModel<T, ContentType> {
    let center: CGPoint
    let input: PopoverInput<T, ContentType>
}

struct PopoverInput<T, ContentType> {
    var content: [ContentType] = []
    let startValue: T?
    let observer: (T) -> Void
}
