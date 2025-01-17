//
//  UIScrollView + Rx.swift
//  SKUify
//
//  Created by George Churikov on 29.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    var reachedBottom: ControlEvent<Void> {
        let observable = contentOffset
            .throttle(
                .seconds(1),
                latest: true,
                scheduler: MainScheduler.instance
            )
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else {
                    return Observable.empty()
                }

                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return y > threshold ? Observable.just(()) : Observable.empty()
            }

        return ControlEvent(events: observable)
    }
        
    
}
