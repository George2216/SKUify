//
//  Marketplaces.swift
//  SKUify
//
//  Created by George Churikov on 13.12.2023.
//

import Foundation
import UIKit

enum Marketplace: String {
    case us
    case ae
    case br
    case ca
    case de
    case eg
    case es
    case fr

}

extension Marketplace {
    var image: UIImage? {
        return UIImage(named: rawValue.uppercased())
    }
    
    var title: String {
        return rawValue.capitalized
    }
}
