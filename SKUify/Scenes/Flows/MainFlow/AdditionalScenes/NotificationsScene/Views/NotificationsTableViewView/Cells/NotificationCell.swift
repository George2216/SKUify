//
//  NotificationCell.swift
//  SKUify
//
//  Created by George Churikov on 26.06.2024.
//

import Foundation
import UIKit
import SnapKit

final class NotificationCell: UITableViewCell {
    
    // MARK: - UI elements
    
    private lazy var notificationTypeImageView = UIImageView()
    
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    private lazy var eventTypeLabel = UILabel()
    private lazy var dateLabel = UILabel()
    
    private lazy var circleView = UIView()
    
    private lazy var titlesStack = VerticalStack()
    private lazy var imageTypeStack = VerticalStack()
    private lazy var mainStack = HorizontalStack()
    private lazy var circleViewStack = VerticalStack()
    private lazy var bottomStack = HorizontalStack()
    private lazy var contentStack = VerticalStack()
    
    // MARK: - Initializers
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        setupContentStack()
        setupTitlesStack()
        setupImageTypeStack()
        setupMainStack()
        setupBottomStack()
        setupCircleViewStack()
        
        setupTitleLabel()
        setupSubtitleLabel()
        setupNotificationTypeImageView()
        setupEventTypeLabel()
        setupDateLabel()
        setupCircleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        notificationTypeImageView.image = UIImage(named: input.type.imageName)
        titleLabel.halfTextColorChange(
            fullText: input.title,
            changeText: input.highlightedTitleText,
            textColor: .primary,
            font: .manrope(
                type: .bold,
                size: 15
            )
        )
        subtitleLabel.text = input.subtitle
        eventTypeLabel.text = input.eventType
        dateLabel.text = input.date
    }
    
    // MARK: - Private methods
    
    private func setupCircleView() {
        circleView.backgroundColor = .primary
        circleView.layer.cornerRadius = 6
        circleView.layer.masksToBounds = true
        circleView.snp.makeConstraints { make in
            make.size
                .equalTo(12)
        }
    }
    
    private func setupDateLabel() {
        dateLabel.font = .manrope(
            type: .medium,
            size: 15
        )
        dateLabel.textColor = .subtextColor
    }
    
    private func setupEventTypeLabel() {
        eventTypeLabel.font = .manrope(
            type: .extraBold,
            size: 12
        )
        eventTypeLabel.textColor = .primaryPink
    }
    
    private func setupNotificationTypeImageView() {
        notificationTypeImageView.contentMode = .scaleAspectFill
        notificationTypeImageView.tintColor = .label
        notificationTypeImageView.backgroundColor = .superLightGray
        notificationTypeImageView.cornerRadius = 12
        notificationTypeImageView.layer.masksToBounds = true
        notificationTypeImageView.snp.makeConstraints { make in
            make.size
                .equalTo(24)
        }
    }
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .bold,
            size: 15
        )
        titleLabel.textColor = .textColor
        titleLabel.numberOfLines = 2
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.font = .manrope(
            type: .semiBold,
            size: 12
        )
        subtitleLabel.textColor = .subtextColor
    }
    
    private func setupCircleViewStack() {
        circleViewStack.views = [
            circleView,
            UIView()
        ]
    }
    
    private func setupBottomStack() {
        bottomStack.views = [
            eventTypeLabel,
            UIView.spacer(for: .horizontal),
            dateLabel
        ]
    }
    
    private func setupMainStack() {
        mainStack.views = [
            imageTypeStack,
            titlesStack,
            circleViewStack
        ]
        mainStack.spacing = 15
    }
 
    private func setupImageTypeStack() {
        imageTypeStack.views = [
            UIView(),
            notificationTypeImageView,
            UIView(),
        ]
        imageTypeStack.distribution = .equalCentering
    }
    
    private func setupTitlesStack() {
        titlesStack.views = [
            titleLabel,
            subtitleLabel,
            bottomStack
        ]
        titlesStack.spacing = 5
    }
    
    private func setupContentStack() {
        contentStack.views = [
            mainStack
        ]
        
        contentView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(10)
        }
    }
    
}

// MARK: - Input

extension NotificationCell {
    struct Input {
        let id: Int
        let type: NotificationType
        let title: String
        let highlightedTitleText: String
        let subtitle: String
        let eventType: String
        let date: String
    }
    
    enum NotificationType: String {
        case sales
        case inventory
        
        fileprivate var imageName: String {
            return self.rawValue + "Bar"
        }
    }
    
}

