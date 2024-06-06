//
//  SharedSequenceConvertibleType.swift
//  RxExtensions
//
//  Created by George Churikov on 17.11.2023.
//


import Foundation
import RxSwift
import RxCocoa

public extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
}


public extension SharedSequence {
    func map<Object: AnyObject, Result>(
        _ obj: Object,
        _ transform: @escaping (Object, Element) -> Result
    ) -> SharedSequence<SharingStrategy, Result> {
        return self.compactMap { [weak obj] element -> Result? in
            guard let obj = obj else { return nil }
            return transform(
                obj,
                element
            )
        }
    }
    
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    func `do`<Object: AnyObject>(
        _ obj: Object,
        _ action: @escaping (Object, Element) -> Void
    ) -> SharedSequence<SharingStrategy, Element> {
        return self.map { [weak obj] element -> Element in
            guard let obj = obj else { return element }
            action(
                obj,
                element
            )
            return element
        }
    }
    
}

public extension SharedSequenceConvertibleType {
    func flatMap<A: AnyObject, O: ObservableConvertibleType>(
        weak obj: A,
        selector: @escaping (A, Self.Element) throws -> O
    ) -> SharedSequence<SharingStrategy, O.Element> {
        return flatMap { [weak obj] value -> SharedSequence<SharingStrategy, O.Element> in
            do {
                return try obj.map { try selector($0, value)
                    .asSharedSequence(onErrorRecover: { _ in .empty() }) } ?? .empty()
            } catch {
                return .empty()
            }
        }
    }
    
    func flatMapFirst<A: AnyObject, O: ObservableConvertibleType>(
        weak obj: A,
        selector: @escaping (A, Self.Element) throws -> O
    ) -> SharedSequence<SharingStrategy, O.Element> {
        return flatMapFirst { [weak obj] value -> SharedSequence<SharingStrategy, O.Element> in
            do {
                return try obj.map { try selector($0, value)
                    .asSharedSequence(onErrorRecover: { _ in .empty() }) } ?? .empty()
            } catch {
                return .empty()
            }
        }
    }
    
    func flatMapLatest<A: AnyObject, O: ObservableConvertibleType>(
        weak obj: A,
        selector: @escaping (A, Self.Element) throws -> O
    ) -> SharedSequence<SharingStrategy, O.Element> {
        return flatMapLatest { [weak obj] value -> SharedSequence<SharingStrategy, O.Element> in
            do {
                return try obj.map { try selector($0, value)
                    .asSharedSequence(onErrorRecover: { _ in .empty() }) } ?? .empty()
            } catch {
                return .empty()
            }
        }
    }
    
}

public extension SharedSequenceConvertibleType where Element: Equatable {
    func filterEqual(_ value: Element) -> SharedSequence<SharingStrategy, Element> {
        return self.asObservable()
            .filter { $0 == value }
            .asSharedSequence(onErrorDriveWith: .empty())
    }
    
}


public extension SharedSequenceConvertibleType {
    func shareElement<O: ObserverType>(_ observer: O) -> SharedSequence<SharingStrategy, Element> where O.Element == Element {
        self.do { element in
            observer.onNext(element)
        }
    }
    
}
