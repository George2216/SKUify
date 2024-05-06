//
//  BannerViewManagerProtocol.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import UIKit

protocol BannerViewManagerProtocol {
    func setup(with window: UIWindow)
    func showBanner(input: BannerView.Input)
}
