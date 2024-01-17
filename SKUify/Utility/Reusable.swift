//
//  Reusable.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import UIKit
import FSCalendar

protocol Reusable: AnyObject {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UIViewController: Reusable {}

extension UITableViewCell: Reusable {}

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

extension FSCalendar {
    func dequeueReusableCell<T>(
        ofType cellType: T.Type = T.self,
        cellFor date: Date,
        at position: FSCalendarMonthPosition
    ) -> T where T: FSCalendarCell {
        
        guard let cell = dequeueReusableCell(
            withIdentifier: cellType.reuseID,
            for: date,
            at: position
        ) as? T else {
            fatalError()
        }
        return cell
    }
}

extension FSCalendar {
    func register<T: Reusable>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
    }
}



