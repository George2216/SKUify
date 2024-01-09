//
//  TimeSlotCollectionView.swift
//  SKUify
//
//  Created by George Churikov on 20.12.2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class TimeSlotCollectionView: ContentResizableCollectionView {
    private let disposeBag = DisposeBag()

    let selectOrDeselect = PublishSubject<Void>()
    
    // MARK: - Initializers

    override init(
        frame: CGRect,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        super.init(
            frame: frame,
            collectionViewLayout: layout
        )

        register(TimeSlotCell.self)
        rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Select first row
    
    override func reloadData() {
        super.reloadData()
        selectItem(
            at: .init(
                row: 0,
                section: 0
            ),
            animated: true,
            scrollPosition: []
        )
    }
    
    // MARK: - Make binding

    func bind(_ collectionData: Driver<[TimeSlotCell.Input]>) -> Disposable {
        collectionData.drive(
            rx.items(
                cellIdentifier: TimeSlotCell.reuseID,
                cellType: TimeSlotCell.self
            )
        ) { row, input ,cell in
            cell.setInput(input)
            cell.row = row
        }
    }
    
}

// MARK: Delegate flow layout

extension TimeSlotCollectionView: UICollectionViewDelegateFlowLayout {
    
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
            top: 15,
            left: 15,
            bottom: 15,
            right: 15
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(
            width: frame.width - 20,
            height: 44
        )
    }
    
}

// MARK: Delegate

extension TimeSlotCollectionView: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldDeselectItemAt indexPath: IndexPath
    ) -> Bool {
        
        collectionView.deselectItem(
            at: indexPath,
            animated: true
        )
        collectionView.performBatchUpdates(nil)
        selectOrDeselect.onNext(())
        return true
    }
    
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
        selectOrDeselect.onNext(())
        return true
    }
    
}


