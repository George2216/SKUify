//
//  BannerView.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import UIKit

final class BannerView: UIView {
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    private let spacing: CGFloat = 15.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
        setupContentLabel()
        setupLayout()
    }
    
    func setup(input: Input) {
        titleLabel.text = input.style.title
        contentLabel.text = input.text
        backgroundColor = input.style.color
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
    }
    
    private func setupContentLabel() {
        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.textColor = .white
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        addSubview(contentLabel)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top
                .equalToSuperview()
                .inset(spacing)
            
            make.leading
                .trailing
                .equalToSuperview()
                .inset(spacing)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(5)
            make.leading
                .trailing
                .equalTo(titleLabel)
            make.bottom
                .equalToSuperview()
                .inset(spacing)
        }
    }
    
    
    override func layoutSubviews() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTitleLabel()
        setupLayout()
    }
    
    enum Style: String {
        case error
        case successfully
        case warning
        
        var color: UIColor {
            switch self {
            case .error:
                return .systemRed
            case .warning:
                return .systemYellow
            case .successfully:
                return .systemGreen
            }
        }
        
        var title: String {
            rawValue.capitalized
        }
    }
    
    struct Input: Equatable {
        let text: String
        let style: Style
        
        public static func == (lhs: Input, rhs: Input) -> Bool {
            return lhs.text == rhs.text &&
            lhs.style == rhs.style
        }
    }
    
}
