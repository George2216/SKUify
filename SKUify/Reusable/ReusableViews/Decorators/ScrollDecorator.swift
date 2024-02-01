//
//  ScrollDecorator.swift
//  SKUify
//
//  Created by George Churikov on 19.01.2024.
//

import UIKit
import SnapKit

final class ScrollDecorator: UIView {
    
    // MARK: - UI elements
    
    private(set) lazy var scrollView = UIScrollView()
    private(set) lazy var containerView = UIView()
    
    private weak var decoratedView: UIView?

    // MARK: - Initializers

    init(_ decoratedView: UIView) {
        self.decoratedView = decoratedView
        super.init(frame: .zero)
        setupScrollView(decoratedView)
        setupContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup views

    private func setupScrollView(_ decoratedView: UIView) {
        // Base scroll settings
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        
        decoratedView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges 
                .equalTo(decoratedView.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .clear
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
            make.width
                .equalTo(scrollView.snp.width)
        }
    }
    
}
