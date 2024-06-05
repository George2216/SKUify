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
    
    private lazy var indicatorImage = UIImageView(image: UIImage.loader)
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        setupIndicatorImage()
        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    // MARK: - Set data

    func setupInput(_ input: Input) {
        titleLabel.text = input.title
        subtitleLabel.text = input.subtitle
    }
    
    // MARK: - Private methods
    
    private func setupIndicatorImage() {
        view.addSubview(indicatorImage)
        
        indicatorImage.snp.makeConstraints { make in
            make.centerX
                .equalToSuperview()
            make.centerY
                .equalToSuperview()
                .inset(125)
            make.size
                .equalTo(250)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .extraBold,
            size: 20
        )
        titleLabel.textColor = .textColor
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top
                .equalTo(indicatorImage.snp.bottom)
                .offset(10)
            make.horizontalEdges
                .equalToSuperview()
                .inset(50)
        }
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.font = .manrope(
            type: .semiBold,
            size: 15
        )
        subtitleLabel.textColor = .lightSubtextColor
        subtitleLabel.textAlignment = .center
        
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(5)
            make.horizontalEdges
                .equalToSuperview()
                .inset(50)
        }
    }
    
    private func showFakeLauncher(_ viewController: UIViewController) {
        viewController.present(self, animated: true) { [weak self] in
            guard let self = self else { return }
            UIView.animate(
                withDuration: 2.0,
                delay: 0,
                options: [.repeat],
                animations: {
                    self.indicatorImage.transform = self.indicatorImage
                        .transform
                        .rotated(by: CGFloat(Double.pi))
                },
                completion: nil
            )
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

// MARK: - Input

extension FakeLauncherViewController {
    struct Input {
        let title: String
        let subtitle: String
    }
    
}
