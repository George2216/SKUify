//
//  COGBaseVC.swift
//  SKUify
//
//  Created by George Churikov on 03.05.2024.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class COGVC: BaseViewController {
    
    var viewModel: COGBaseViewModel!
    
    // MARK: UI elements
    
    private lazy var collectionView = COGCollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    private lazy var calendarPopover = SingleCalendarPopoverVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let output = viewModel.transform(.init(selectedCalendarDate: calendarPopover.didSelectDate.asDriverOnErrorJustComplete()))
        
        setupCollection()
        
        bindToTitle(output)
        bindHeightForScrollingToTxtField(output)
        bindToCollectionView(output)
        bingCalendarPopover(output)
        bindToLoader(output)
        bindToBanner(output)
        bindToAlert(output)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        return layout
    }
    
    private func setupCollection() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }

}

// MARK: Make binding

extension COGVC {
    
    private func bindToTitle(_ output: COGBaseViewModel.Output) {
        output.title
            .drive(rx.title)
            .disposed(by: disposeBag)
    }
    
    private func bindHeightForScrollingToTxtField(_ output: COGBaseViewModel.Output) {
        output.keyboardHeight
            .map(self) { owner, height in
                UIScrollView.ScrollToVisibleContext(
                    height: height,
                    view: owner.view
                )
            }
            .drive(collectionView.rx.scrollToVisibleTextField)
            .disposed(by: disposeBag)
    }
    
    private func bindToLoader(_ output: COGBaseViewModel.Output) {
        output.fetching
            .drive(rx.loading)
            .disposed(by: disposeBag)
    }
    
    private func bindToBanner(_ output: COGBaseViewModel.Output) {
        output.error
            .drive(rx.banner)
            .disposed(by: disposeBag)
    }
    
    private func bindToCollectionView(_ output: COGBaseViewModel.Output) {
        collectionView.bind(output.collectionData)
            .disposed(by: disposeBag)
    }
    
    private func bingCalendarPopover(_ output: COGBaseViewModel.Output) {
        output.showCalendarPopover
            .map(self) { owner, center in
                PopoverManager.Input(
                    bindingType: .point(center),
                    preferredSize: .init(
                        width: owner.view.frame.width - 20,
                        height: owner.view.frame.width - 110
                    ),
                    popoverVC: owner.calendarPopover
                )
            }
            .drive(rx.popover)
            .disposed(by: disposeBag)
    }
    
    private func bindToAlert(_ output: COGBaseViewModel.Output) {
        output.alert
            .drive(rx.alert)
            .disposed(by: disposeBag)
    }
    
}

