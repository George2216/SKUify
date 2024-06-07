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
    private let onError = PublishSubject<Error>()
    private let onComplete = PublishSubject<String>()

    fileprivate func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onError: { [weak self] error in
                guard let self = self else { return }
                self.onError(error)
            }, onDispose: {
                print("Dispose")
            })
    }

    func trackComplete<O: ObservableConvertibleType>(
        from source: O,
        message: String
    ) -> Observable<O.Element> {
        return source.asObservable()
            .do(onCompleted: { [weak self] in
                guard let self else { return }
                self.onComplete.onNext(message)
            } , onDispose: {
                print("Dispose")
            })
    }

    func asBannerInput() -> SharedSequence<SharingStrategy, BannerView.Input> {
        Observable.merge(
            onError.map { error in
                BannerView.Input(
                    text: error.localizedDescription,
                    style: .error
                )
            },
            onComplete.map { message in
                BannerView.Input(
                    text: message,
                    style: .successfully
                )
            }
        )
        .asDriverOnErrorJustComplete()
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return onError.asObservable()
            .asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return onError.asObservable()
    }

    func asBannerInput(_ style: BannerView.Style) -> SharedSequence<SharingStrategy, BannerView.Input> {
        return onError.map { error in
            BannerView.Input(
                text: error.localizedDescription,
                style: style
            )
        }
        .asDriverOnErrorJustComplete()
    }

    private func onError(_ error: Error) {
        onError.onNext(error)
    }

    private func onComplete(_ message: String) {
        onComplete.onNext(message)
    }

    deinit {
        onError.onCompleted()
        onComplete.onCompleted()
    }

}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }

    func trackComplete(
        _ errorTracker: ErrorTracker,
        message: String
    ) -> Observable<Element> {
        return errorTracker.trackComplete(
            from: self,
            message: message
        )
    }

}
