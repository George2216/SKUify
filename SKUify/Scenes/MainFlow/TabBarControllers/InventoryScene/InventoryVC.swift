//
//  InventoryVC.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class InventoryVC: BaseViewController {
    
    private lazy var setupView = InventorySetupView()
    private lazy var collectionView = ProductsCollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    var viewModel: InventoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inventory"
        let output = viewModel.transform(.init())
        
        setupSetupView()
        
        bindToSetupView(output)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        return layout
    }
    
    private func setupSetupView() {
        view.addSubview(setupView)
        setupView.snp.makeConstraints { make in
            make.top
                .horizontalEdges
                .equalToSuperview()
                .inset(10)
        }
    }
    
}

// MARK: Make binding

extension InventoryVC {
    private func bindToSetupView(_ output: InventoryViewModel.Output) {
        output.setupViewInput
            .drive(setupView.rx.input)
            .disposed(by: disposeBag)
    }
    
}
