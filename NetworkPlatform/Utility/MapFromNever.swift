//
//  MapFromNever.swift
//  NetworkPlatform
//
//  Created by George Churikov on 31.01.2024.
//

import Foundation
import RxSwift
import RxCocoa

struct MapFromNever: Error {}
extension ObservableType where Element == Never {
    func map<T>(to: T.Type) -> Observable<T> {
        return self.flatMap { _ in
            return Observable<T>.error(MapFromNever())
        }
    }
}
