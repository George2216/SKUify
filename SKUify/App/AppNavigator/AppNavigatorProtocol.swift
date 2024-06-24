//
//  AppNavigatorProtocol.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation

protocol AppNavigatorProtocol {
    func toLoginFlow()
    func toMainFlow()
    func showFakeLuncher(isShow: Bool)
    func showBanner(input: BannerView.Input)
}
