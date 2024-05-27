//
//  ExpensesVC.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ExpensesVC: BaseViewController {
    
    private let visibleSection = PublishSubject<Int>()

    var viewModel: ExpensesViewModel!
    
    // MARK: UI elements
    
    private lazy var collectionView = ExpensesCollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    private lazy var rightBarButton = DefaultBarButtonItem()
    private lazy var leftBarButton = DefaultBarButtonItem()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Expenses"
        
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
        
        setupCollection()
        subscribeOnVisibleSection()
        sutupNavBarItems()
        
        bindToTitle(output)
        bindToLoader(output)
        bindToBanner(output)
        bindToCollectionView(output)
        bindToRightBarButton(output)
        bindToLeftBarButton(output)
        bingCalendarPopover(output)
        bindToSimpleTablePopover(output)
        bindToPaginatedCollectionLoader(output)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        return layout
    }
    
    private func sutupNavBarItems() {
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupCollection() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }

}

// MARK: Subscribers

extension ExpensesVC {
    
    private func subscribeOnVisibleSection() {
        collectionView
            .subscribeOnVisibleSection()
            .drive(visibleSection)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Make binding

extension ExpensesVC {
    
    private func bindToTitle(_ output: ExpensesViewModel.Output) {
        output.title
            .drive(rx.title)
            .disposed(by: disposeBag)
    }
    
    private func bindToLoader(_ output: ExpensesViewModel.Output) {
        output.fetching
            .drive(collectionView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindToBanner(_ output: ExpensesViewModel.Output) {
        output.error
            .drive(rx.banner)
            .disposed(by: disposeBag)
    }
    
    
    private func bindToCollectionView(_ output: ExpensesViewModel.Output) {
        collectionView.bind(output.collectionData)
            .disposed(by: disposeBag)
    }
    
    private func bindToRightBarButton(_ output: ExpensesViewModel.Output) {
        output.rightBarButtonConfig
            .drive(rightBarButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToLeftBarButton(_ output: ExpensesViewModel.Output) {
        output.leftBarButtonConfig
            .drive(leftBarButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bingCalendarPopover(_ output: ExpensesViewModel.Output) {
        output.showCalendarPopover
            .withUnretained(self)
            .map { owner, model in
                PopoverManager.Input(
                    bindingType: .point(model.center),
                    preferredSize: .init(
                        width: owner.view.frame.width - 20,
                        height: owner.view.frame.width - 110
                    ),
                    popoverVC: SingleCalendarPopoverVC()
                        .bild(model.input)
                )
            }
            .drive(rx.popover)
            .disposed(by: disposeBag)
    }
    
    private func bindToSimpleTablePopover(_ output: ExpensesViewModel.Output) {
        output.showSimpleTablePopover
            .withUnretained(self)
            .map { owner, model in
                PopoverManager.Input(
                    bindingType: .point(model.center),
                    preferredSize: .init(
                        width: owner.view.frame.width / 1.5,
                        height: min(CGFloat(model.input.content.count * 40), 240)
                    ),
                    popoverVC: SimpleTablePopoverVC()
                        .build(model.input)
                )
            }
            .drive(rx.popover)
            .disposed(by: disposeBag)
    }
    
    private func bindToPaginatedCollectionLoader(_ output: ExpensesViewModel.Output) {
        collectionView.bindToPaginatedLoader(output.isShowPaginatedLoader)
            .disposed(by: disposeBag)
    }
    
}
