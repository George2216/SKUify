//
//  PopoverManager.swift
//  SKUify
//
//  Created by George Churikov on 29.11.2023.
//

import Foundation
import UIKit

final class PopoverManager: PopoverManagerProtocol {
    static let shared: PopoverManagerProtocol = PopoverManager()
    
    private var baseController: (UIViewController & UIPopoverPresentationControllerDelegate)?
    
    private init() { }
    
    func setup(from show: UIViewController & UIPopoverPresentationControllerDelegate) {
        baseController = show
    }
    
    func showPopover(_ input: Input) {
        let popoverContentViewController = input.popoverVC
        popoverContentViewController.modalPresentationStyle = .popover
        
        if let popoverPresentationController = popoverContentViewController.popoverPresentationController {
            popoverPresentationController.sourceView = viewAtPoint(input.pointView)
            popoverPresentationController.permittedArrowDirections = .any
            popoverPresentationController.delegate = baseController
            
            if let preferredSize = input.preferredSize {
                popoverContentViewController.preferredContentSize = preferredSize
            }
            
            baseController?.present(popoverContentViewController, animated: true, completion: nil)
        }
    }
    
}

extension PopoverManager {
    struct Input {
        let pointView: CGPoint
        var preferredSize: CGSize? = nil
        let popoverVC: UIViewController
    }
    
}

extension PopoverManager {
   private func viewAtPoint(_ point: CGPoint) -> UIView? {
        if let window = UIWindow.key {
            return window.hitTest(point, with: nil)
        }
        return nil
    }
}