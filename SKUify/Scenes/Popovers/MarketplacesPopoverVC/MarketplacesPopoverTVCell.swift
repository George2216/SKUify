//
//  MarketplacesPopoverTVCell.swift
//  SKUify
//
//  Created by George Churikov on 04.03.2024.
//

import UIKit
import SnapKit

final class MarketplacesPopoverTVCell: UITableViewCell {

    private lazy var titledMarketplace = TitledMarketplace()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitledMarketplace()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        titledMarketplace.setInput(input.marketplace)
    }
    
    private func setupTitledMarketplace() {
        contentView.addSubview(titledMarketplace)
        titledMarketplace.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(10)
        }
    }
}

extension MarketplacesPopoverTVCell {
    struct Input: Equatable {
        let marketplace: TitledMarketplace.Input
        
        static func ==(
            lhs: Input,
            rhs: Input
        ) -> Bool {
            return lhs.marketplace == rhs.marketplace
        }
    }
}
