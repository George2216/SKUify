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

    var disposeBag = DisposeBag()
  
    private let popoverManager = PopoverManager()
    private let alertManager = AlertManager.share
    private let bannerManager = BannerViewManager.shared
    private let loaderManager = LoaderManager.shared
    
    // MARK: - UI Elements
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

        setNavBarTranslucent()
        popoverManager.setup(from: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackButton()
    }
    
    // MARK: - Popover Handling

    fileprivate func showPopover(_ input: PopoverManager.Input) {
        popoverManager.showPopover(input)
    }
    
    // MARK: - Banner Handling
    
    fileprivate func showBanner(_ input: BannerView.Input) {
        bannerManager.showBanner(input: input)
    }
    
    // MARK: - Indicator Handling

    fileprivate func startLoadingIndicator(_ isLoading: Bool) {
       loaderManager.showLoader(isLoading)
    }
    
    fileprivate func showAlert(_ type: AlertManager.AlertType) {
        alertManager.showAlert(type)
    }
    
    // MARK: - Navigation bar settings

    private func setNavBarTranslucent() {
        navigationController?.navigationBar.isTranslucent = false // This is needed to ensure that the background view does not interfere with the navigation bar.
    }
    
    private func setupBackButton() {
        // This one removes back button title
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.backIndicatorImage = .back
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = .back
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
        return Binder(base) { controller, isLoading in
            controller.startLoadingIndicator(isLoading)
        }
    }
    
    var banner: Binder<BannerView.Input> {
        return Binder(base) { controller, bannerInput in
            controller.showBanner(bannerInput)
        }
    }
    
    var popover: Binder<PopoverManager.Input> {
        return Binder(base) { controller, popoverInput in
            controller.showPopover(popoverInput)
        }
    }
    
    var alert: Binder<AlertManager.AlertType> {
        return Binder(base) { controller, alertType in
            controller.showAlert(alertType)
        }
    }
    
}
