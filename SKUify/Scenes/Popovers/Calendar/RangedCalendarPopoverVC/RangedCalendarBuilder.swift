//
//  RangedCalendarBuilder.swift
//  SKUify
//
//  Created by George Churikov on 12.01.2024.
//

import Foundation
import UIKit

protocol RangedCalendarPopoverDelegate: AnyObject {
    func selectedCalendarDates(
        startDate: Date,
        endDate: Date?
    )
}

final class RangedCalendarBuilder {
    static func buildRangedCalendarModule(delegate: RangedCalendarPopoverDelegate) -> UIViewController {
        let viewModel = RangedCalendarViewModel()
        let vc = RangedCalendarPopoverVC()
        vc.delegate = delegate
        vc.viewModel = viewModel
        return vc
    }
    
}
