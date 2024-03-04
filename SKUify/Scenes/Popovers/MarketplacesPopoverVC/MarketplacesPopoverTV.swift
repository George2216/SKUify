//
//  MarketplacesPopoverTV.swift
//  SKUify
//
//  Created by George Churikov on 04.03.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class MarketplacesPopoverTV: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerCell() {
        register(MarketplacesPopoverTVCell.self)
    }
    
    func bind(_ tableData: Driver<[MarketplacesPopoverTVCell.Input]>) -> Disposable {
        tableData.drive(
            rx.items(
                cellIdentifier: MarketplacesPopoverTVCell.reuseID,
                cellType: MarketplacesPopoverTVCell.self
            )
        ) { index, element, cell in
            cell.setupInput(element)
        }
    }
}

