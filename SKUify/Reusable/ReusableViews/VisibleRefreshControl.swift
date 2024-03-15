//
//  VisibleRefreshControl.swift
//  SKUify
//
//  Created by George Churikov on 13.03.2024.
//

import Foundation
import UIKit

final class VisibleRefreshControl: UIRefreshControl {
    override func endRefreshing() {
        super.endRefreshing()
        isHidden = true
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        isHidden = false
    }
    
}
