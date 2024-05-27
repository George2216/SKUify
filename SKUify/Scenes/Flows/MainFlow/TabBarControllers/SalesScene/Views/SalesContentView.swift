//
//  SalesContentView.swift
//  SKUify
//
//  Created by George Churikov on 02.02.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SalesContentView: UIView {
    fileprivate var disposeBag = DisposeBag()

    private lazy var salesSetupView = SalesSetupView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(salesSetupView)
        salesSetupView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        bindToSetupView(input)
    }
    
    private func bindToSetupView(_ input: Input) {
        input.setupViewInput
            .drive(salesSetupView.rx.input)
            .disposed(by: disposeBag)
    }
    
}

extension SalesContentView {
    struct Input {
        let setupViewInput: Driver<SalesSetupView.Input>
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: SalesContentView {
    var input: Binder<SalesContentView.Input> {
        return Binder(self.base) { view, input in
            view.disposeBag = DisposeBag()
            view.setupInput(input)
        }
    }
    
}
