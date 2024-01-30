//
//  RxImagePickerDelegateProxy.swift
//  SKUify
//
//  Created by George Churikov on 29.01.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
 
func dismissViewController(
    _ viewController: UIViewController,
    animated: Bool
) {
    viewController.dismiss(animated: animated, completion: nil)
}

extension Reactive where Base: UIImagePickerController {
    static func createWithParent(
        _ parent: UIViewController?,
        animated: Bool = true,
        configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { x in }
    ) -> Driver<UIImagePickerController> {
        
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            
            let dismissDisposable = imagePicker.rx
                .didCancel
                .drive(onNext: { [weak imagePicker] _ in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(
                        imagePicker,
                        animated: animated
                    )
                })
            
            do {
                try configureImagePicker(imagePicker)
            } catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }

            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }

            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))
            
            return Disposables.create(
                dismissDisposable,
                Disposables.create {
                dismissViewController(
                    imagePicker,
                    animated: animated
                )
            })
            
        }
        .asDriver(onErrorJustReturn: UIImagePickerController())
    }
}

extension Reactive where Base: UIImagePickerController {
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Driver<[UIImagePickerController.InfoKey : Any]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(
                    Dictionary<UIImagePickerController.InfoKey, Any>.self,
                    a[1]
                )
            })
            .asDriverOnErrorJustComplete()
    }
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Driver<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
            .asDriverOnErrorJustComplete()
    }
    
}

private func castOrThrow<T>(
    _ resultType: T.Type,
    _ object: Any
) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError
            .castingError(
                object: object,
                targetType: resultType
            )
    }
    return returnValue
}

open class RxImagePickerDelegateProxy: RxNavigationControllerDelegateProxy, UIImagePickerControllerDelegate {
    
    public init(imagePicker: UIImagePickerController) {
        super.init(navigationController: imagePicker)
    }
    
}
