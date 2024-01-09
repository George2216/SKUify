//
//  DashboardCollectionView.swift
//  SKUify
//
//  Created by George Churikov on 03.12.2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift

final class DashboardCollectionView: UICollectionView {
    private let disposeBag = DisposeBag()
        
    // MARK: Data source

    private lazy var customSource =  RxCollectionViewSectionedReloadDataSource<DashboardSectionModel> { dataSource, collectionView, indexPath, item in
        
        switch item {
        case .financialMetric(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: FinancialMetricDashboardCell.self,
                at: indexPath
            )
            cell.setInput(input)
            return cell
        case .overview(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: OverviewDashboardCell.self,
                at: indexPath
            )
            cell.setInput(input)
            return cell
        case .marketplace(let input):
            let cell = collectionView.dequeueReusableCell(
                ofType: MarketplaceDashboardCell.self,
                at: indexPath
            )
            cell.setInput(input)
            return cell
        }
        
    }
    
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
    }
    
    private func registerCells() {
        register(FinancialMetricDashboardCell.self)
        register(OverviewDashboardCell.self)
        register(MarketplaceDashboardCell.self)
    }
    
    
    // MARK: Bind to collection

    func bind(_ sections: Driver<[DashboardSectionModel]>) -> Disposable {
       return sections.drive(rx.items(dataSource: customSource))
    }
    
}

// MARK: Delegate flow layout


extension DashboardCollectionView: UICollectionViewDelegateFlowLayout {
    
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
        let section = customSource
            .sectionModels[section].identity
        switch section {
        case .marketplaceSection:
            return 0
        default:
            return 10
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = collectionView.bounds.width - 40

            let item = customSource
            .sectionModels[indexPath.section]
            .items[indexPath.item]

           switch item {
           case .financialMetric(let input):
               let cell = FinancialMetricDashboardCell()
               cell.setInput(input)
               let height = cell
                   .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                   .height
               return CGSize(
                width: (width - 10) / 2,
                height: height
               )
           case .overview:
               
               return CGSize(
                width: width,
                height: 350
               )
               
           case .marketplace(let input):
               let isSelected = collectionView.indexPathsForSelectedItems?
                   .contains(indexPath) ?? false

               let cell = MarketplaceDashboardCell()
               cell.isSelected = isSelected
               cell.setInput(input)
               cell.frame = .init(
                origin: .zero,
                size: .init(
                    width: width,
                    height: 1000
                )
               )
               
               cell.setNeedsLayout()
               cell.layoutIfNeeded()
              
               let size = cell.systemLayoutSizeFitting(
                          CGSize(
                            width: width,
                            height: .greatestFiniteMagnitude
                          ),
                          withHorizontalFittingPriority: .required,
                          verticalFittingPriority: .defaultLow
                      )
              
               return size
           }
       }
    
}

// MARK: Delegate

extension DashboardCollectionView: UICollectionViewDelegate {
    
    // Override the method for animated cell compression
    func collectionView(
        _ collectionView: UICollectionView,
        shouldDeselectItemAt indexPath: IndexPath
    ) -> Bool {
        guard indexPath.section == 2 else { return true}
        
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates(nil)
        return true
    }
    
    // Override the method for animated cell expansion
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        guard indexPath.section == 2 else { return true}

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionView.performBatchUpdates(nil)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        return true
    }
    
}

