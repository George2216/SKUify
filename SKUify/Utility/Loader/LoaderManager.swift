//
//  LoaderManager.swift
//  SKUify
//
//  Created by George Churikov on 08.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class LoaderManager: LoaderManagerProtocol {
    
    static let shared: LoaderManagerProtocol = LoaderManager()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private var window: UIWindow?
    
    private init() {}
    
    func setup(with window: UIWindow) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.window = window
            self.addLoaderOnSuperview(superview: window)
        }
    }
    
    func showLoader(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        window?.isUserInteractionEnabled = !isLoading
    }
    
    private func addLoaderOnSuperview(
        superview: UIView
    ) {
        superview.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
    }
    
}
