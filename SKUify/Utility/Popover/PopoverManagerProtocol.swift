//
//  PopoverManagerProtocol.swift
//  SKUify
//
//  Created by George Churikov on 29.11.2023.
//

import Foundation
import UIKit

protocol PopoverManagerProtocol {
    associatedtype Input
    func setup(from show: UIViewController & UIPopoverPresentationControllerDelegate)
    func showPopover(_ input: Input)
}
