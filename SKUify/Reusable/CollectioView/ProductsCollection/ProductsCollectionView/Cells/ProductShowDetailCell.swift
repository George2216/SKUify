//
//  ProductShowDetailCell.swift
//  SKUify
//
//  Created by George Churikov on 06.03.2024.
//

import UIKit
import SnapKit

final class ProductShowDetailCell: UICollectionViewCell {
    
    // MARK: - UI Elements

    private lazy var titleLabel = UILabel()
    private lazy var arrowImageView = UIImageView()

    // Rotate arrow image by isSelected changes
    override var isSelected: Bool {
        didSet {
            transformArrowImage()
        }
    }
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
        setupArrowImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(
            [
                .bottomLeft,
                .bottomRight
            ],
            radius: 15
        )
        contentView.backgroundColor = .primaryLight
            .withAlphaComponent(0.2)
    }
    
    private func transformArrowImage() {
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi / 2 )
            self.arrowImageView.transform = self.isSelected ? upsideDown : .identity
        }
    }
    
    func setupWigth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width
                .equalTo(width)
            make.edges
                .equalToSuperview()
        }
    }
    
    // MARK: - Setup views
    
    private func setupArrowImageView() {
        arrowImageView.image = .arrow
          
        arrowImageView.contentMode = .scaleAspectFit
        contentView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.leading
                .equalTo(titleLabel.snp.trailing)
                .offset(5)
            make.centerY
                .equalToSuperview()
        }

    }
    
    private func setupTitleLabel() {
        titleLabel.text = "View Details"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .primary

        titleLabel.font = .manrope(
            type: .bold,
            size: 13
        )
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges
                .equalToSuperview()
                .inset(10)
            make.centerX
                .equalToSuperview()
        }
    }
    
}
