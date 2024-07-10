//
//  NotificationsCollectionView.swift
//  SKUify
//
//  Created by George Churikov on 26.06.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class NotificationsTableViewView: UITableView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Data source
    
    private lazy var customSource = RxTableViewSectionedReloadDataSource<NotificationsSectionModel>(
        configureCell: { [unowned self] dataSource, tableView, indexPath, item in
                        
            switch item {
            case .notification(let input):
                let cell = tableView.dequeueReusableCell(
                    ofType: NotificationCell.self,
                    at: indexPath
                )
                cell.setupInput(input)
                
                return cell
                
            }
            
    }) { dataSource, section in
        return dataSource.sectionModels[section].model.headerFooter.header
    }
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: Initializers
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTable()
        registerCells()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Privete methods

    private func setupTable() {
        refreshControl = VisibleRefreshControl()
        tableFooterView = activityIndicator
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        rowHeight = UITableView.automaticDimension
        rx.itemDeleted.subscribe(onNext: { _ in
        }).disposed(by: disposeBag)
        rx.modelSelected(NotificationsCollectionItem.self)
            .subscribe(onNext: { data in
                print(data)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Register cells

    private func registerCells() {
        register(NotificationCell.self)
    }
    
    // MARK: - Bind to collection

    func bind(_ sections: Driver<[NotificationsSectionModel]>) -> Disposable {
       return sections.drive(rx.items(dataSource: customSource))
    }
    
    func bindToPaginatedLoader(_ isShowLoader: Driver<Bool>) -> Disposable {
        isShowLoader.drive(activityIndicator.rx.isAnimating)
    }
    
    func selectById() -> Driver<Int> {
        rx.modelSelected(NotificationsCollectionItem.self)
            .map { $0.mapToId() }
            .asDriverOnErrorJustComplete()
    }
    
    func removeById() -> Driver<Int> {
        rx.modelDeleted(NotificationsCollectionItem.self)
            .map { $0.mapToId() }
            .asDriverOnErrorJustComplete()
    }
    
}

