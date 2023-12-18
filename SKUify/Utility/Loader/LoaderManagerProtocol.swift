//
//  LoaderManagerProtocol.swift
//  SKUify
//
//  Created by George Churikov on 08.12.2023.
//

import Foundation
import UIKit

protocol LoaderManagerProtocol {
    func setup(with windowScene: UIWindowScene)
    func showLoader(_ isLoading: Bool)
}
