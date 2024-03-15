//
//  ActivityTracker.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import RxSwift
import RxCocoa

public class ActivityTracker: SharedSequenceConvertibleType {
    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _behavior = BehaviorRelay<Bool>(value: false)
    private let _loading: SharedSequence<SharingStrategy, Bool>
        
    public init() {
        _loading = _behavior.asDriver()
//            .distinctUntilChanged() When the screen is relaunched, if the previous event has not completed, it is necessary to retrieve the same event.
    }

    public func stopTracker() {
        _lock.unlock()
        _behavior.accept(false)
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(
        _ source: O
    ) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }
    
    private func subscribed() {
        _lock.lock()
        _behavior.accept(true)
        _lock.unlock()
    }
    
    public func sendStopLoading() {
        _lock.lock()
        _behavior.accept(false)
        _lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
    
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: ActivityTracker) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
