//
//  LoaderCollectionReusableView.swift
//  SKUify
//
//  Created by George Churikov on 12.03.2024.
//

import Foundation
import UIKit

final class LoaderCollectionReusableView: UICollectionReusableView {
      func setupActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY
                .centerX
                .equalToSuperview()
        }
    }

}



