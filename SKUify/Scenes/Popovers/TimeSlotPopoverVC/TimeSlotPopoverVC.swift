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
    private let disposeBag = DisposeBag()

    // MARK: - UIElemetns
    
    private lazy var collectionView = TimeSlotCollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }
    
    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        subscribeOnItemSelected()
    }

    // MARK: - Make binding

    func bindToCollection(_ collectionData: Driver<[TimeSlotCell.Input]>) -> Disposable {
        return collectionView.bind(collectionData)
    }
    
    private func subscribeOnItemSelected() {
        collectionView.selectOrDeselect
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
            .drive(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Setup view

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}


