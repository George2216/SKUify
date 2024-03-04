//
//  SalesCollectionView.swift
//  SKUify
//
//  Created by George Churikov on 05.02.2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift
import SnapKit

final class SalesCollectionView: UICollectionView {
    private let disposeBag = DisposeBag()

    private let visibleSections = PublishSubject<Int>()
    
    // MARK: Data source

    private lazy var customSource = RxCollectionViewSectionedReloadDataSource<SalesSectionModel>(configureCell: { [unowned self] dataSource, collectionView, indexPath, item in
        self.visibleSections.onNext(indexPath.section)
        let width = self.frame.width - 40
        switch item {
        case .orders(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: SalesOrdersCell.self,
                at: indexPath
            )
            cell.setupWigth(width)
            cell.setupInput(input)
            
            return cell
        case .refunds(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: SalesRefundsCell.self,
                at: indexPath
            )
            cell.setupWigth(width)
            cell.setupInput(input)
            return cell
        }
        
    }) { [unowned self] dataSource, collectionView, kind, indexPath in
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofType: LoaderView.self,
                at: indexPath,
                kind: kind
            )

            footer.setupActivityIndicator(self.activityIndicator)
            return footer
        }
        return UICollectionReusableView()
    }
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: Initializers
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollection()
        registerCells()
        rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Privete methods

    private func setupCollection() {
        refreshControl = UIRefreshControl()

        backgroundColor = .clear
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        allowsMultipleSelection = true
        alwaysBounceVertical = true
    }
    
    private func registerCells() {
        register(SalesOrdersCell.self)
        register(SalesRefundsCell.self)
        register(
            LoaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoaderView.reuseID
        )
        
    }
    
    // MARK: Bind to collection

    func bind(_ sections: Driver<[SalesSectionModel]>) -> Disposable {
       return sections.drive(rx.items(dataSource: customSource))
    }
    
    func bindToPaginatedLoader(_ isShowLoader: Driver<Bool>) -> Disposable {
        isShowLoader.drive(activityIndicator.rx.isAnimating)
    }
    
    func subscribeOnVisibleSection() -> Driver<Int> {
        visibleSections.asDriverOnErrorJustComplete()
    }
     
}

extension SalesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        guard customSource.sectionModels.count - 1 == section else { return .zero }
        return CGSize(
            width: collectionView.bounds.width,
            height: 50
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10.0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 10,
            left: 20,
            bottom: 10,
            right: 20
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
}

// MARK: Delegate

extension SalesCollectionView: UICollectionViewDelegate {
    // Override the method for animated cell compression
    func collectionView(
        _ collectionView: UICollectionView,
        shouldDeselectItemAt indexPath: IndexPath
    ) -> Bool {
        collectionView.deselectItem(
            at: indexPath,
            animated: true
        )
        collectionView.performBatchUpdates(nil)
        return true
    }
    
    // Override the method for animated cell expansion
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        collectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: []
        )
        collectionView.performBatchUpdates(nil)
        collectionView.scrollToItem(
            at: indexPath,
            at: .top,
            animated: true
        )
        return true
    }
    
}

final class LoaderView: UICollectionReusableView {
      func setupActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY
                .centerX
                .equalToSuperview()
        }
    }

}



