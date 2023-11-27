//
//  ViewModelProtocol.swift
//  SKUify
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation

protocol ViewModelProtocol  {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
