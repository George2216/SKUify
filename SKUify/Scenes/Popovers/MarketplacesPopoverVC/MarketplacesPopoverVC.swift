//
//  MarketplacesPopoverVC.swift
//  SKUify
//
//  Created by George Churikov on 01.03.2024.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MarketplacesPopoverVC: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var tableView = MarketplacesPopoverTV()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
    func bind(_ tableData: Driver<[MarketplacesPopoverTVCell.Input]>) -> Disposable {
        tableView.bind(tableData)
    }

    func itemSelected() -> Driver<String> {
        tableView.rx.modelSelected(MarketplacesPopoverTVCell.Input.self)
            .map { $0.marketplace.counryCode }
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .map { $1 }
    }
    
}

