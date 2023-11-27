//
//  FakeLauncherViewController.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import UIKit
import SnapKit

class FakeLauncherViewController: UIViewController {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .red
        view.addSubview(activityIndicator)
        activityIndicator.color = .black
        activityIndicator.snp.makeConstraints { make in
            make.centerX
                .centerY
                .equalToSuperview()
        }
    }

    private func showFakeLauncher(_ viewController: UIViewController) {
        viewController.present(self, animated: true) { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.startAnimating()
        }
    }
    
    private func hideFakeLauncher(_ viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }

}

extension FakeLauncherViewController: FakeLauncherViewControllerProtocol {
    func startFakeLauncher(
        from viewController: UIViewController,
        isShow: Bool
    ) {
        isShow ?
        showFakeLauncher(viewController) :
        hideFakeLauncher(viewController)
    }
    
}


