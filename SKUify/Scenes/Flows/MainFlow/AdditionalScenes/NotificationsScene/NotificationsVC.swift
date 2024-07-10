//
//  NotificationsVC.swift
//  SKUify
//
//  Created by George Churikov on 07.06.2024.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class NotificationsVC: BaseViewController {
    
    // MARK: - UI elements
    
    private lazy var tableView = NotificationsTableViewView(
        frame: .zero,
        style: .plain
    )
    
    private lazy var clearAllBarButton = DefaultBarButtonItem()
    
    var viewModel: NotificationsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        
        let refreshingTriger = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let output = viewModel.transform(
            .init(
                reloadData: Driver.merge(refreshingTriger, viewDidAppear),
                reachedBottom: tableView.rx.reachedBottom.asDriver(),
                selectById: tableView.selectById(),
                removeById: tableView.removeById()
            )
        )
        
        setupTable()
        sutupNavBarItems()
        
        bindToBanner(output)
        bindToTableView(output)
        bindToLoader(output)
        bindToPaginatedCollectionLoader(output)
        bindToClearAllBarButton(output)
        
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top
                .equalToSuperview()
            make.horizontalEdges
                .bottom
                .equalToSuperview()
        }
    }
    
    private func sutupNavBarItems() {
        navigationItem.rightBarButtonItem = clearAllBarButton
    }
    
}

// MARK: Make binding

extension NotificationsVC {
    
    private func bindToLoader(_ output: NotificationsViewModel.Output) {
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindToBanner(_ output: NotificationsViewModel.Output) {
        output.error
            .drive(rx.banner)
            .disposed(by: disposeBag)
    }
    
    private func bindToTableView(_ output: NotificationsViewModel.Output) {
        tableView.bind(output.tableData)
            .disposed(by: disposeBag)
    }
    
    private func bindToPaginatedCollectionLoader(_ output: NotificationsViewModel.Output) {
        tableView.bindToPaginatedLoader(output.isShowPaginatedLoader)
            .disposed(by: disposeBag)
    }
    
    private func bindToClearAllBarButton(_ output: NotificationsViewModel.Output) {
        output.clearAllButtonConfig
            .drive(clearAllBarButton.rx.config)
            .disposed(by: disposeBag)
    }
    
}
