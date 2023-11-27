//
//  ClickableLabel.swift
//  SKUify
//
//  Created by George Churikov on 25.11.2023.
//

import Foundation
import UIKit
import RxSwift

final class ClickableLabel: UILabel {
    
    private var disposeBag = DisposeBag()
    
    // Store the range of clickable text and the font for the clickable text
    private var clickableRange = NSRange(
        location: NSNotFound,
        length: 0
    )
    private var clickableFont: UIFont?

    // MARK: - Make binding
    
    fileprivate func makeBinding(_ config: Config) {
        disposeBag = DisposeBag()
        clickableFont = UIFont.manrope(
            type: .bold,
            size: 16
        )
        
        setupBaseText()
        clickableRange = setupTextAttributed(config)
        setupTap(tap: config.action)
    }

    // MARK: - Private methods

    private func setupBaseText() {
        font = clickableFont
        textAlignment = .center
        textColor = textColor
    }
    
    private func setupTextAttributed(_ config: Config) -> NSRange {
        let clickableAttribute = NSMutableAttributedString(string: config.fullText)
        let range = (config.fullText as NSString)
            .range(of: config.clickableText)
        
        clickableAttribute.addAttribute(
            .font,
            value: clickableFont ?? .init(),
            range: range
        )
        
        clickableAttribute.addAttribute(
            .foregroundColor,
            value: UIColor.primaryLight,
            range: range
        )
        
        self.attributedText = clickableAttribute
        return range
    }

    private func setupTap(tap: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()

        tapGesture.rx.event
            .bind { [weak self] gesture in
                guard let self = self else { return }
                self.handleTap(
                    gesture: gesture,
                    action: tap
                )
            }
            .disposed(by: disposeBag)

        self.addGestureRecognizer(tapGesture)
    }

    private func handleTap(
        gesture: UITapGestureRecognizer,
        action: (() -> Void)?
    ) {
        let locationOfTouchInLabel = gesture.location(in: self)
        let indexOfCharacter = getCharacterIndex(at: locationOfTouchInLabel)

        if NSLocationInRange(
            indexOfCharacter,
            clickableRange
        ) {
            action?()
        }
    }

    private func getCharacterIndex(at point: CGPoint) -> Int {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: attributedText!)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.size = bounds.size

        let locationOfTouchInTextContainer = CGPoint(
            x: point.x,
            y: point.y
        )
        return layoutManager.characterIndex(
            for: locationOfTouchInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
    }
}

// MARK: - Input

extension ClickableLabel {
    struct Config {
        var fullText: String
        var clickableText: String
        var action: (() -> Void)?
    }
}

// MARK: - Custom binding

extension Reactive where Base: ClickableLabel {
    var config: Binder<ClickableLabel.Config> {
        return Binder(self.base) { label, input in
            label.makeBinding(input)
        }
    }
}
