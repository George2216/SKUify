//
//  BaseViewController.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class BaseViewController: UIViewController {
    // MARK: - Properties

    let disposeBag = DisposeBag()
  
    
    // MARK: - UI Elements
    
    private var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

        setNavBarTranslucent()
        setupLoadingIndicator()
        PopoverManager.shared.setup(from: self)
    }
    
    // MARK: - Popover Handling

    fileprivate func showPopover(_ input: PopoverManager.Input) {
        PopoverManager.shared
            .showPopover(input)
    }
    
    // MARK: - Banner Handling
    
    fileprivate func showBanner(_ input: BannerView.Input) {
        BannerViewManager.shared
            .showBanner(input: input)
    }
    
    // MARK: - Indicator Handling

    fileprivate func startLoadingIndicator(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        view.isUserInteractionEnabled = !isLoading
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .black
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.centerY
                .centerX
                .equalToSuperview()
        }
    }
    
    // MARK: - Navigation bar settings

    private func setNavBarTranslucent() {
        navigationController?.navigationBar.isTranslucent = false // This is needed to ensure that the background view does not interfere with the navigation bar.
    }
    
}
extension BaseViewController {
   private func viewAtPoint(_ point: CGPoint) -> UIView? {
        if let window = UIWindow.key {
            return window.hitTest(point, with: nil)
        }
        return nil
    }
}

// MARK: - Popover delegate methods

extension BaseViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}


// MARK: - Binding

extension Reactive where Base: BaseViewController {
    var loading: Binder<Bool> {
        return Binder(self.base) { controller, isLoading in
            controller.startLoadingIndicator(isLoading)
        }
    }
    
    var banner: Binder<BannerView.Input> {
        return Binder(self.base) { controller, bannerInput in
            controller.showBanner(bannerInput)
        }
    }
    
    var popover: Binder<PopoverManager.Input> {
        return Binder(base) { controller, popoverInput in
            controller.showPopover(popoverInput)
        }
    }
    
}
