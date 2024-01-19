//
//  ProfileVC.swift
//  SKUify
//
//  Created by George Churikov on 18.01.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ProfileVC: BaseViewController {
    
    // Dependencies
    var viewModel: ProfileViewModel!
    
    // MARK: UI elements
    
    private lazy var scrollDecarator = ScrollDecorator(view)
    private lazy var containerView = scrollDecarator.containerView
    private lazy var scrollView = scrollDecarator.scrollView

    private lazy var contentView = ProfileContentView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        let output = viewModel.transform(.init())
        setupContentView()
        
        bindToContentView(output)
    }
    
    private func bindToContentView(_ output: ProfileViewModel.Output) {
        output.contentData
            .drive(contentView.rx.input)
            .disposed(by: disposeBag)
    }
    
    private func setupContentView() {
        containerView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.horizontalEdges
                .equalToSuperview()
                .inset(16)
            make.bottom
                .lessThanOrEqualToSuperview()
        }
    }
}

