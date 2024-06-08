//
//  BaseAlertVC.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import UIKit
import RxSwift
import RxCocoa

class BaseAlertVC: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var visualEffectView = UIVisualEffectView()
    
    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        super.init(
            nibName: nil,
            bundle: nil
        )
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisualEffectView()
        setupDismissGesture()
    }
    
    override func dismiss(
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        view.window?.layer.add(
            CATransition.alertTransition(),
            forKey: kCATransition
        )
        super.dismiss(
            animated: flag,
            completion: completion
        )
    }
    
    private func setupVisualEffectView() {
        visualEffectView.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        visualEffectView.alpha = 0.6
        view.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.size
                .equalToSuperview()
        }
    }
    
    private func setupDismissGesture() {
        let tapGesture = UITapGestureRecognizer()
        
        tapGesture.rx.event
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
        visualEffectView.addGestureRecognizer(tapGesture)
    }
    
}

extension BaseAlertVC: BaseAlertProtocol {
    func hideAlert() {
        dismiss(animated: false)
    }
    
}
