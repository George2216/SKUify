//
//  SimpleTableView.swift
//  SKUify
//
//  Created by George Churikov on 20.05.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleTableView: UITableView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(
        _ titles: Driver<[String]>
    ) -> Disposable {
        titles.drive(rx.items(cellType: SimpleTableViewCell.self)) { row, title, cell in
            cell.setupTitle(title)
        }
    }
    
    func subscribeOnRowSelected() -> Driver<Int> {
        rx.itemSelected
            .map { $0.row }
            .asDriverOnErrorJustComplete()
    }
    
    func select(at row: Int) {
        selectRow(
            at: .init(
            row: row,
            section: 0
        ), 
            animated: false,
            scrollPosition: .top
        )
    }
    
    // MARK: - Private methods
    
    private func registerCells() {
        register(SimpleTableViewCell.self)
    }
        
}
