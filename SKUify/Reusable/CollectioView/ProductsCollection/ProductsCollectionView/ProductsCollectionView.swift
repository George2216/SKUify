//
//  ProductsCollectionView.swift
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

final class ProductsCollectionView: UICollectionView {
    private let disposeBag = DisposeBag()
    
    // MARK: Data source

    private lazy var customSource = RxCollectionViewSectionedReloadDataSource<ProductsSectionModel>(configureCell: { [unowned self] dataSource, collectionView, indexPath, item in
        
        let width = self.frame.width - 20
        
        switch item {
        case .main(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: ProductMainCell.self,
                at: indexPath
            )
            cell.setupWigth(width)
            cell.setupInput(input)
            
            return cell
        case .contentCell(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: ProductContentCell.self,
                at: indexPath
            )
            cell.setupInput(input)
            cell.setupWigth(width)
            return cell
        case .showDetail:
            let cell = collectionView.dequeueReusableCell(
                ofType: ProductShowDetailCell.self,
                at: indexPath
            )
            cell.setupWigth(width)
            
            return cell
        }
        
    }) { [unowned self] dataSource, collectionView, kind, indexPath in
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofType: LoaderCollectionReusableView.self,
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
    
    override init(
        frame: CGRect,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        super.init(
            frame: frame,
            collectionViewLayout: layout
        )
        setupCollection()
        registerCells()
        rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Privete methods

    private func setupCollection() {
        refreshControl = VisibleRefreshControl()
        backgroundColor = .clear
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        allowsMultipleSelection = true
    }
    
    // MARK: - Register cells

    private func registerCells() {
        register(ProductMainCell.self)
        register(ProductShowDetailCell.self)
        register(ProductContentCell.self)

        registerFooter(LoaderCollectionReusableView.self)
        
    }
    
    // MARK: - Bind to collection

    func bind(_ sections: Driver<[ProductsSectionModel]>) -> Disposable {
       return sections.drive(rx.items(dataSource: customSource))
    }
    
    func bindToPaginatedLoader(_ isShowLoader: Driver<Bool>) -> Disposable {
        isShowLoader.drive(activityIndicator.rx.isAnimating)
    }
     
}

// MARK: - DelegateFlowLayout

extension ProductsCollectionView: UICollectionViewDelegateFlowLayout {
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
            left: 0,
            bottom: 10,
            right: 0
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        let count = customSource.sectionModels[section].items.count
        
        if let isSelected = collectionView.cellForItem(at: .init(row: count - 1, section: section))?.isSelected {
            return isSelected ? 1 : 0
        }
        return 0
    }
    
}

// MARK: Delegate

extension ProductsCollectionView: UICollectionViewDelegate {

    // Override the method for animated cell compression
    func collectionView(
        _ collectionView: UICollectionView,
        shouldDeselectItemAt indexPath: IndexPath
    ) -> Bool {
        let itemsCount = customSource
            .sectionModels[indexPath.section]
            .items
            .count

        guard indexPath.row == itemsCount - 1 else { return false }

        for row in 0..<itemsCount {
            collectionView.deselectItem(
                at: .init(row: row, section: indexPath.section),
                animated: true
            )
        }

        collectionView.performBatchUpdates(nil)
        return true
    }

    // Override the method for animated cell expansion
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let itemsCount = customSource
            .sectionModels[indexPath.section]
            .items
            .count


        let item = customSource
            .sectionModels[indexPath.section]
            .items[indexPath.item]

        guard item ~= .showDetail else { return false }

        for row in 0..<itemsCount {
            collectionView.selectItem(
                at: .init(row: row, section: indexPath.section),
                animated: true,
                scrollPosition: []
            )
        }

        collectionView.performBatchUpdates(nil)

        return true
    }

}

