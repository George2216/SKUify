//
//  Reusable.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import UIKit
import FSCalendar
import RxSwift
import RxCocoa

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
        register(
            cellClass,
            forCellReuseIdentifier: cellClass.reuseID
        )
    }
}

extension UICollectionReusableView: Reusable {}

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
    
    func dequeueReusableSupplementaryView<T>(
        ofType cellType: T.Type = T.self,
        at indexPath: IndexPath,
        kind: String
    ) -> T where T: UICollectionReusableView {
        guard let supplementaryView = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: cellType.reuseID,
            for: indexPath
        ) as? T else {
            fatalError()
        }
        return supplementaryView
    }
    
}

extension UICollectionView {
    func register<T: Reusable>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseID)
    }
    
    func registerFooter<T: Reusable>(_ cellClass: T.Type) {
        register(
            cellClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: cellClass.reuseID
        )
    }
    
    func registerHeader<T: Reusable>(_ cellClass: T.Type) {
        register(
            cellClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: cellClass.reuseID
        )
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

extension Reactive where Base: UITableView {
    public func items<Sequence: Swift.Sequence, Cell: UITableViewCell, Source: ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: Source)
        -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
        -> Disposable
        where Source.Element == Sequence {
            return items(
                cellIdentifier: cellType.reuseID,
                cellType: cellType.self
            )
    }
    
}
