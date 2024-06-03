//
//  ExpensesCollectionView.swift
//  SKUify
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class ExpensesCollectionView: UICollectionView {
    private let disposeBag = DisposeBag()
    private var cashe: [IndexPath: CGFloat] = [:]
    
    // MARK: Data source
    
    private lazy var customSource = RxCollectionViewSectionedReloadDataSource<ExpensesSectionModel>(
        configureCell: { [unowned self] dataSource, collectionView, indexPath, item in
            let width = collectionView.frame.width - 20

            switch item {
            case .expenses(let input):
                let cell = collectionView.dequeueReusableCell(
                    ofType: ExpensesCell.self,
                    at: indexPath
                )
                cell.setupInput(input)
                cell.setupWigth(width)

                return cell
            }
            
        }) { [unowned self] dataSource, collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofType: ExpensesHeaderReusableView.self,
                    at: indexPath,
                    kind: kind
                )
                let header = dataSource.sectionModels[indexPath.section].model.headerFooter.header
                
                headerView.setupInput(.init(title: header))
                return headerView
                
            case UICollectionView.elementKindSectionFooter:
                let footer = collectionView.dequeueReusableSupplementaryView(
                    ofType: LoaderCollectionReusableView.self,
                    at: indexPath,
                    kind: kind
                )
                
                footer.setupActivityIndicator(self.activityIndicator)
                return footer
                
            default:
                return UICollectionReusableView()
            }
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
        keyboardDismissMode = .interactive
    }
    
    // MARK: - Register cells

    private func registerCells() {
        register(ExpensesCell.self)

        registerHeader(ExpensesHeaderReusableView.self)
        registerFooter(LoaderCollectionReusableView.self) // loader
    }
    
    // MARK: - Bind to collection
    
    func bind(_ sections: Driver<[ExpensesSectionModel]>) -> Disposable {
        sections.drive(rx.items(dataSource: customSource))
    }
    
    func bindToPaginatedLoader(_ isShowLoader: Driver<Bool>) -> Disposable {
        isShowLoader.drive(activityIndicator.rx.isAnimating)
    }
    
}

// MARK: - DelegateFlowLayout

extension ExpensesCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        
        let header = customSource
            .sectionModels[section].model.headerFooter.header
        guard !header.isEmpty else { return .zero }
        
        let headerView = ExpensesHeaderReusableView()
        headerView.setupInput(.init(title: header))
        headerView.snp.makeConstraints { make in
            make.width
                .equalTo(collectionView.frame.width - 20)
                .priority(.required)
        }
        return headerView
            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
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
        return 0
    }
    
}

