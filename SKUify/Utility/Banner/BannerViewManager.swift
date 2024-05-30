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
    private var hideTimer: Timer?
    
    private let animationDuration: TimeInterval = 0.3
    private let bannerDuration: TimeInterval = 2
    
    private var showConstaint: Constraint!
    private var hideConstaint: Constraint!

    private var isShow: Bool = false {
        didSet {
            updateConstaints()
        }
    }
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
            self.showBanner()
            
            self.hideTimer?.invalidate()
            self.hideTimer = Timer.scheduledTimer(
                timeInterval: self.bannerDuration,
                target: self,
                selector: #selector(self.hideBanner),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    
    private func updateConstaints() {
        guard let bannerView else { return }
        guard let superview = bannerView.superview else { return }
        showConstaint.isActive = isShow
        hideConstaint.isActive = !isShow
        
        UIView.animate(withDuration: animationDuration) {
            superview.layoutIfNeeded()
        }
    }
    
    private func setupBanner() -> UIView {
        let banner = BannerView()
        
        let swipeGesture = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleSwipe(_:))
        )
        swipeGesture.direction = .up
        banner.addGestureRecognizer(swipeGesture)
        
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
            make.horizontalEdges
                .equalToSuperview()
                .inset(14)
        }
        
        bannerView.snp.prepareConstraints { make in
            showConstaint = make.top
                .equalTo(superview.safeAreaLayoutGuide)
                .constraint
            hideConstaint = make.bottom
                .equalTo(superview.snp.top)
                .constraint
        }
    }
    
    private func showBanner() {
        isShow = true
    }

    @objc private func hideBanner() {
        isShow = false
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        hideBanner()
    }
    
}
