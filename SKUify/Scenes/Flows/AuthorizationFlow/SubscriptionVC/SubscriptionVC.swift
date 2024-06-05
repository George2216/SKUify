//
//  SubscriptionVC.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SubscriptionVC: BaseViewController {
    
    var viewModel: SubscriptionViewModel!
    
    // MARK: - UI elements
    
    private lazy var titleLabel = UILabel()

    private lazy var collectionView = SubscribtionCollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage.titleImage)

        let output = viewModel.transform(.init())
        
        setupTitleLabel()
        setupCollectionView()
        
        bindToTitle(output)
        bindToLoader(output)
        bindToBanner(output)
        bindToCollectionView(output)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .bold,
            size: 24
        )
        titleLabel.textColor = .textColor
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top
                .horizontalEdges
                .equalToSuperview()
                .inset(20)
            make.height
                .equalTo(30)
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges
                .bottom
                .equalToSuperview()
        }
    }
    
}

// MARK: - Make binding

extension SubscriptionVC {
    
    private func bindToTitle(_ output: SubscriptionViewModel.Output) {
        output.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToLoader(_ output: SubscriptionViewModel.Output) {
        output.fetching
            .drive(rx.loading)
            .disposed(by: disposeBag)
    }
    
    private func bindToBanner(_ output: SubscriptionViewModel.Output) {
        output.error
            .drive(rx.banner)
            .disposed(by: disposeBag)
    }
    
    private func bindToCollectionView(_ output: SubscriptionViewModel.Output) {
        collectionView.bind(output.collectionData)
            .disposed(by: disposeBag)
    }
    
}
