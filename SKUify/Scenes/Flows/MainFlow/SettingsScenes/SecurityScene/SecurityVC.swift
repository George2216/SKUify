//
//  SecurityVC.swift
//  SKUify
//
//  Created by George Churikov on 05.06.2024.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SecurityVC: BaseViewController {
    
    // Dependencies
    var viewModel: SecurityViewModel!
    
    // MARK: UI elements
    
    private lazy var scrollDecarator = ScrollDecorator(view)
    private lazy var containerView = scrollDecarator.containerView
    private lazy var scrollView = scrollDecarator.scrollView

    private lazy var contentView = SecurityContentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Security"
        
        let output = viewModel.transform(.init())
        
        setupContentView()
        
        bindHeightForScrollingToTxtField(output)
        bindToLoader(output)
        bindToBanner(output)
        bindToContentView(output)
    }
    
    private func setupContentView() {
        containerView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top
                .horizontalEdges
                .equalToSuperview()
                .inset(16)
            make.bottom
                .equalToSuperview()
        }
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
}

// MARK: Make binding

extension SecurityVC {
    
    private func bindHeightForScrollingToTxtField(_ output: SecurityViewModel.Output) {
        output.keyboardHeight
            .map(self) { owner, height in
                UIScrollView.ScrollToVisibleContext(
                    height: height,
                    view: owner.view
                )
            }
            .drive(scrollView.rx.scrollToVisibleTextField)
            .disposed(by: disposeBag)
    }
    
    private func bindToLoader(_ output: SecurityViewModel.Output) {
        output.fetching
            .drive(rx.loading)
            .disposed(by: disposeBag)
    }
    
    private func bindToBanner(_ output: SecurityViewModel.Output) {
        output.error
            .drive(rx.banner)
            .disposed(by: disposeBag)
    }
    
    private func bindToContentView(_ output: SecurityViewModel.Output) {
        output.contentData
            .drive(contentView.rx.input)
            .disposed(by: disposeBag)
    }
    
}
