//
//  SalesOrdersCell.swift
//  SKUify
//
//  Created by George Churikov on 06.02.2024.
//

import UIKit
import SnapKit

final class SalesOrdersCell: UICollectionViewCell {
    private lazy var productMainView = ProductMainView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupProductMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        setupProductMainView(input)
    }
    
    func setupWigth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width.equalTo(width)
        }
    }
    
    private func setupProductMainView(_ input: Input) {
        productMainView.setupInput(input.mainViewInput)
    }
    
    private func setupProductMainView() {
        contentView.addSubview(productMainView)
        productMainView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
}


extension SalesOrdersCell {
    struct Input {
        let mainViewInput: ProductMainView.Input
    }
    
}
