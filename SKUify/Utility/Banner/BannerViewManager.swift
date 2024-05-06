//
//  BannerViewManager.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class BannerViewManager: BannerViewManagerProtocol {
    
    static let shared: BannerViewManagerProtocol = BannerViewManager()
    
    private var bannerView: BannerView?
    
    private let animationDuration: TimeInterval = 0.3
    
    private init() {}
    
    func setup(with window: UIWindow) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let banner = self.setupBanner()
                self.addBannerOnSuperview(
                    superview: window,
                    bannerView: banner
                )
            }
    }
    
    func showBanner(input: BannerView.Input) {
        guard let bannerView = bannerView else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            bannerView.setup(input: input)
            self.animateBannerViewShow(bannerView)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.animateBannerViewHide(bannerView)
            }
        }
    }
    
    private func setupBanner() -> UIView {
        let banner = BannerView()
        banner.isHidden = true
        banner.alpha = 0
        
        guard bannerView != nil else {
            bannerView = banner
            return banner
        }
        bannerView?.removeFromSuperview()
        bannerView = banner
        return banner
    }
    
    private func addBannerOnSuperview(
        superview: UIView,
        bannerView: UIView
    ) {
        superview.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.top
                .equalTo(superview.safeAreaLayoutGuide)
            make.leading
                .equalToSuperview()
                .inset(14)
            make.trailing
                .equalToSuperview()
                .inset(14)
        }
    }
    
    private func animateBannerViewShow(_ bannerView: UIView) {
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                bannerView.isHidden = false
                bannerView.alpha = 1
            }
        )
    }
    
    private func animateBannerViewHide(_ bannerView: UIView) {
        UIView.animate(
            withDuration: animationDuration * 2,
            animations: {
                bannerView.alpha = 0
            }, completion: { _ in
                bannerView.isHidden = true
            }
        )
    }
    
}
