//
//  TimeSlotPopoverVC.swift
//  SKUify
//
//  Created by George Churikov on 20.12.2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TimeSlotPopoverVC: UIViewController {

    private lazy var collectionView = TimeSlotCollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func bindToCollection(_ collectionData: Driver<[TimeSlotCell.Input]>) -> Disposable {
        return collectionView.bind(collectionData)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}
