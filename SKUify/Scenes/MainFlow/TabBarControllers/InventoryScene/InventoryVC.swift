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

    private let visibleSection = PublishSubject<Int>()

    // MARK: - UI elements
    
    private lazy var setupView = InventorySetupView()
    private lazy var collectionView = ProductsCollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    var viewModel: InventoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inventory"
        
        let refreshingTriger = collectionView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        // Hide the refresh control when dismiss the screen, otherwise it will hang.
        let viewDidDisappear = rx.sentMessage(#selector(UIViewController.viewDidDisappear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let output = viewModel.transform(
            .init(
                reloadData: Driver.merge(refreshingTriger, viewDidAppear),
                screenDisappear: viewDidDisappear,
                visibleSection: visibleSection.asDriverOnErrorJustComplete()
            )
        )
        
        setupSetupView()
        setupCollection()
        subscribeOnVisebleSection()
        
        bindToLoader(output)
        bindToBanner(output)
        bindToSetupView(output)
        bindToCollectionView(output)
        bindToPaginatedCollectionLoader(output)
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
    
    private func setupCollection() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top
                .equalTo(setupView.snp.bottom)
                .offset(10)
            make.horizontalEdges
                .bottom
                .equalToSuperview()
        }
    }
    
}

// MARK: Subscribers

extension InventoryVC {
    
    private func subscribeOnVisebleSection() {
        collectionView
            .subscribeOnVisibleSection()
            .drive(visibleSection)
            .disposed(by: disposeBag)
    }
    
}

// MARK: Make binding

extension InventoryVC {
    
    private func bindToLoader(_ output: InventoryViewModel.Output) {
        output.fetching
            .drive(collectionView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindToBanner(_ output: InventoryViewModel.Output) {
        output.error
            .drive(rx.banner)
            .disposed(by: disposeBag)
    }
    
    private func bindToSetupView(_ output: InventoryViewModel.Output) {
        output.setupViewInput
            .drive(setupView.rx.input)
            .disposed(by: disposeBag)
    }
    
    private func bindToCollectionView(_ output: InventoryViewModel.Output) {
        collectionView.bind(output.collectionData)
            .disposed(by: disposeBag)
    }
    
    private func bindToPaginatedCollectionLoader(_ output: InventoryViewModel.Output) {
        collectionView.bindToPaginatedLoader(output.isShowPaginatedLoader)
            .disposed(by: disposeBag)
    }
    
}
