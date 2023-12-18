//
//  NetworkProvider.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation

public protocol NetworkProvider {
    func makeLoginNetwork() -> Domain.LoginNetwork
}

