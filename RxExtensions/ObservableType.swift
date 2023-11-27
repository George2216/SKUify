//
//  ObservableType.swift
//  RxExtensions
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import RxSwift
import RxCocoa

public extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

public extension ObservableType {
    
    func flatMap<A: AnyObject, O: ObservableType>(
        weak obj: A,
        selector: @escaping (A, Self.Element) throws -> O
    ) -> Observable<O.Element> {
        return flatMap { [weak obj] value -> Observable<O.Element> in
            try obj.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }
    
    func flatMapFirst<A: AnyObject, O: ObservableType>(
        weak obj: A,
        selector: @escaping (A, Self.Element) throws -> O
    ) -> Observable<O.Element> {
        return flatMapFirst { [weak obj] value -> Observable<O.Element> in
            try obj.map { try selector($0, value)
                .asObservable() } ?? .empty()
        }
    }
    
    func flatMapLatest<A: AnyObject, O: ObservableType>(
            weak obj: A,
            selector: @escaping (A, Self.Element) throws -> O
        ) -> Observable<O.Element> {
            return self.flatMapLatest { [weak obj] value -> Observable<O.Element> in
                guard let strongObj = obj else {
                    return Observable.empty()
                }
                do {
                    return try selector(strongObj, value).asObservable()
                } catch {
                    return Observable.error(error)
                }
            }
        }
}

public extension ObservableType where Element: Equatable {
    func filterEqual(_ value: Element) -> Observable<Element> {
        return self.filter { $0 == value }
    }
}
