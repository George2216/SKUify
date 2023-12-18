//
//  Reusable.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import UIKit

protocol Reusable: AnyObject {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}

extension UIViewController: Reusable {}

extension UITableView {
    func dequeueReusableCell<T>(
        ofType cellType: T.Type = T.self,
        at indexPath: IndexPath
    ) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellType.reuseID,
            for: indexPath
        ) as? T else {
            fatalError()
        }
        return cell
    }
}

extension UITableView {
    func register<T: Reusable>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
    }
}


extension UICollectionViewCell: Reusable {}

extension UICollectionView {
    func dequeueReusableCell<T>(
        ofType cellType: T.Type = T.self,
        at indexPath: IndexPath
    ) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: cellType.reuseID,
            for: indexPath
        ) as? T else {
            fatalError()
        }
        return cell
    }
}

extension UICollectionView {
    func register<T: Reusable>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseID)
    }
}



