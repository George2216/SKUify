//
//  PopoverManager.swift
//  SKUify
//
//  Created by George Churikov on 29.11.2023.
//

import Foundation
import UIKit

final class PopoverManager: PopoverManagerProtocol {
    
    private weak var baseController: (UIViewController & UIPopoverPresentationControllerDelegate)?
        
    func setup(from vc: (UIViewController & UIPopoverPresentationControllerDelegate)) {
        baseController = vc
    }
    
    func showPopover(_ input: Input) {
        let popoverContentViewController = input.popoverVC
        
        //Exit if the controller has already been presented
        guard popoverContentViewController.presentingViewController == nil else { return }

        popoverContentViewController.modalPresentationStyle = .popover
        popoverContentViewController.isModalInPresentation = false
        

        if let popoverPresentationController = popoverContentViewController.popoverPresentationController {
            
            switch input.bindingType {
            case .point(let center):
                popoverPresentationController.sourceView = viewAtPoint(center)
            case .view(let view):
                popoverPresentationController.sourceView = view
            }
            
            popoverPresentationController.permittedArrowDirections = .any
            popoverPresentationController.delegate = baseController
            if let preferredSize = input.preferredSize {
                popoverContentViewController.preferredContentSize = preferredSize
            }

            baseController?.present(popoverContentViewController, animated: true, completion: nil)
        }
    }
    
    
    
}

// MARK: - Input

extension PopoverManager {
    struct Input {
        let bindingType: BindingType
        var preferredSize: CGSize? = nil
        let popoverVC: UIViewController
    }
    
    enum BindingType {
        case view(_ view: UIView)
        case point(_ point: CGPoint)
    }

}

// MARK: - Find view by point

extension PopoverManager {
   private func viewAtPoint(_ point: CGPoint) -> UIView? {
        if let window = UIWindow.key {
            return window.hitTest(point, with: nil)
        }
        return nil
    }
}
