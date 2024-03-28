//
//  SimpleAlertVC.swift
//  SKUify
//
//  Created by George Churikov on 25.03.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SimpleAlertVC: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var visualEffectView = UIVisualEffectView()
    
    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisualEffectView()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        view.window?.layer.add(CATransition.alertTransition(), forKey: kCATransition)
        super.dismiss(animated: flag, completion: completion)
    }
    
    private func setupVisualEffectView() {
        visualEffectView.effect = UIBlurEffect(style: .light)
        view.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.size
                .equalToSuperview()
        }
    }
    
    private func setupDismissGesture() {
        let tapGesture = UITapGestureRecognizer()
        
        tapGesture.rx.event
            .bind { [weak self] gesture in
                guard let self = self else { return }
                self.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        view.addGestureRecognizer(tapGesture)
    }
    
}

