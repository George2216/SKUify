//
//  SubscribtionCollectionView.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import RxDataSources

final class SubscribtionCollectionView: ContentResizableCollectionView {
    
    private let disposeBag = DisposeBag()
    
    private lazy var customSource = RxCollectionViewSectionedReloadDataSource<SubscriptionSectionModel>(
        configureCell: { [unowned self] dataSource, collectionView, indexPath, item in
            switch item {
            case .subscribtion(let input):
                let cell = collectionView.dequeueReusableCell(
                    ofType: SubscribtionCell.self,
                    at: indexPath
                )
                cell.setupInput(input)
                cell.setupWidth(collectionView.bounds.width - 20)
                return cell
            }
            
        })
    
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
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerCells() {
        register(SubscribtionCell.self)
    }
    
    private func setupCollection() {
        alwaysBounceHorizontal = true
        backgroundColor = .clear
        isPagingEnabled = true

        rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func bind(_ sections: Driver<[SubscriptionSectionModel]>) -> Disposable {
        sections.drive(rx.items(dataSource: customSource))
    }
    
}

// MARK: - DelegateFlowLayout

extension SubscribtionCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = collectionView.bounds.width - 20
        
        let item = customSource
            .sectionModels[indexPath.section]
            .items[indexPath.item]
        
        switch item {
        case .subscribtion(let input):
            let cell = SubscribtionCell()
            cell.setupInput(input)
            cell.layoutIfNeeded()
            
            let height = cell.layoutSizeFitting
                .height
            
            if height > collectionView.frame.height - 100 {
                return .init(
                    width: width,
                    height: collectionView.frame.height - 100
                )
            }

            return .init(
                width: width,
                height: height
            )
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 10,
            right: 0
        )
    }
    
}
