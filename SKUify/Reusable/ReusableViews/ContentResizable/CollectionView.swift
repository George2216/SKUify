//
//  CollectionView.swift
//  SKUify
//
//  Created by George Churikov on 20.12.2023.
//

import Foundation
import UIKit

class ContentResizableCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: contentSize.height + contentInset.bottom + contentInset.top
        )
    }
}
