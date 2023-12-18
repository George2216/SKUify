//
//  ErrorTracker.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxExtensions

final class ErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onError: { [weak self] error in
                guard let self = self else { return }
                self.onError(error)
                }, onCompleted: {
                    print("Completed")
                } , onDispose: {
                    print("Dispose")
                }
            )
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable()
            .asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }
    
    func asBannerInput(_ style: BannerView.Style) -> SharedSequence<SharingStrategy, BannerView.Input> {
        return _subject.map { error in
            BannerView.Input(
                text: error.localizedDescription,
                style: style
            )
        }
        .asDriverOnErrorJustComplete()
    }
    
    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
