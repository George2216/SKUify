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

final class SubscribtionCollectionView: ContentResizableCollectionView {
    private let disposeBag = DisposeBag()

    override init(
        frame: CGRect,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        super.init(
            frame: frame,
            collectionViewLayout: layout
        )
        backgroundColor = .red
        registerCells()
        alwaysBounceHorizontal = true
      
        rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerCells() {
        register(SubscribtionCell.self)
    }
    
    func bind(_ data: Driver<[SubscribtionCell.Input]>) -> Disposable {
        data.drive(rx.items(cellType: SubscribtionCell.self)) { row, data , cell in
            cell.setupInput(data)
        }
    }
    
}

// MARK: - DelegateFlowLayout

extension SubscribtionCollectionView: UICollectionViewDelegateFlowLayout {
  
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        print(collectionView.bounds.size)
        return collectionView.bounds.size
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

