//
//  TitledMarketplace.swift
//  SKUify
//
//  Created by George Churikov on 13.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class TitledMarketplace: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInput(_ input: Input) {
        imageView.image = UIImage(named: input.counryCode)
        titleLabel.text = input.countryTitle
    }

    
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .bold,
            size: 15
        )
        titleLabel.textColor = .textColor
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY
                .equalToSuperview()
            make.leading
                .equalTo(imageView.snp.trailing)
                .offset(5)
        }
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 7.0
        imageView.layer.masksToBounds = true
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.directionalVerticalEdges
                .equalToSuperview()
            make.leading
                .equalToSuperview()
            make.size
                .equalTo(20)
        }
    }
}

extension TitledMarketplace {
    struct Input: Equatable {
        let countryTitle: String
        let counryCode: String
        
        static func allMarketplaces() -> Input {
            return .init(
                countryTitle: "All marketplaces",
                counryCode: "allMarketplaces"
            )
        }
        
        static func ==(
            lhs: Input,
            rhs: Input
        ) -> Bool {
            return lhs.countryTitle == rhs.countryTitle &&
            lhs.counryCode == rhs.counryCode
        }
    }
    
}
