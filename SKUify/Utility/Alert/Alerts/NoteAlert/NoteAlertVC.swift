//
//  NoteAlertVC.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NoteAlertVC: BaseAlertVC {
    private let disposeBag = DisposeBag()

    private lazy var alertView = NoteAlertView()
    
    var viewModel: NoteAlertViewModel!
    
    convenience init(_ input: NoteAlertView.Input) {
        self.init(nibName: nil, bundle: nil)
        alertView.setupInput(input)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.transform(.init())
        
        setupAlertView()

        bindToAlertBottomPosition(output)
    }
    
    private func setupAlertView() {
        alertView.delegate = self
        
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.bottom
                .equalToSuperview()
                .inset(50)
            make.horizontalEdges
                .equalToSuperview()
                .inset(30)
        }
    }
    
    private func updateAlertViewBottomPosition(_ keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 1) {
            self.alertView.snp.updateConstraints { make in
                make.bottom
                    .equalToSuperview()
                    .inset(50 + keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: - Make binding

extension NoteAlertVC {
    private func bindToAlertBottomPosition(_ output: NoteAlertViewModel.Output) {
        output.keyboardHeight
            .withUnretained(self)
            .drive(onNext: { owner, keyboardHeight in
                owner.updateAlertViewBottomPosition(keyboardHeight)
            })
            .disposed(by: disposeBag)
    }
    
}
