//
//  COGCollectionView.swift
//  SKUify
//
//  Created by George Churikov on 30.03.2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift
import SnapKit

final class COGCollectionView: UICollectionView {
    private let disposeBag = DisposeBag()

    // MARK: Data source
    
    private lazy var customSource = RxCollectionViewSectionedReloadDataSource<COGSectionModel>(
        configureCell: { [unowned self] dataSource, collectionView, indexPath, item in
        let width = self.frame.width - 20

        switch item {
        case .main(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: COGMainCell.self,
                at: indexPath
            )
            cell.setupWigth(width)
            cell.setupInput(input)
            return cell
            
        case .purchaseDetail(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: COGPurchaseDetailCell.self,
                at: indexPath
            )
            cell.setupWigth(width)
            cell.setupInput(input)
            return cell
            
        case .costOfGoods(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: COGCostOfGoodsCell.self,
                at: indexPath
            )
            cell.setupWigth(width)
            cell.setupInput(input)
            return cell
            
        case .costSummary(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: COGCostSummaryCell.self,
                at: indexPath
            )
            cell.setupWigth(width)
            cell.setupInput(input)
            return cell
            
        case .importStrategy(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: COGImportStrategyCell.self,
                at: indexPath
            )
            cell.setupWigth(width)
            cell.setupInput(input)
            return cell
        case .applyToInventory(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: COGApplyToInventoryCell.self,
                at: indexPath
            )
            cell.setupWigth(width)
            cell.setupInput(input)
            return cell
        }
        }) { [unowned self] dataSource, collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofType: COGHeaderReusableView.self,
                    at: indexPath,
                    kind: kind
                )
                let header = dataSource.sectionModels[indexPath.section].model.headerFooter.header
                
                headerView.setupInput(.init(title: header))
                return headerView
            }
            return UICollectionReusableView()
        }
    
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
        backgroundColor = .clear
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        allowsMultipleSelection = true
        keyboardDismissMode = .interactive
    }
    
    // MARK: - Register cells

    private func registerCells() {
        register(COGMainCell.self)
        register(COGPurchaseDetailCell.self)
        register(COGCostOfGoodsCell.self)
        register(COGCostSummaryCell.self)
        register(COGImportStrategyCell.self)
        register(COGApplyToInventoryCell.self)
        registerHeader(COGHeaderReusableView.self)
    }
    
    // MARK: - Bind to collection
    
    func bind(_ sections: Driver<[COGSectionModel]>) -> Disposable {
        sections.drive(rx.items(dataSource: customSource))
    }
    
}

// MARK: - DelegateFlowLayout

extension COGCollectionView: UICollectionViewDelegateFlowLayout {
 
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        
        let header = customSource
            .sectionModels[section].model.headerFooter.header
        guard !header.isEmpty else { return .zero }
        
        let headerView = COGHeaderReusableView()
        headerView.setupInput(.init(title: header))
        let height = headerView
            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            .height
        return CGSize(
            width: (collectionView.frame.width - 10) / 2,
         height: height
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
        return 0
    }
    
}

