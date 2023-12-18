//
//  CalendarPopoverVC.swift
//  SKUify
//
//  Created by George Churikov on 03.12.2023.
//

import Foundation
import UIKit

final class CalendarPopoverVC: UIViewController {
    let calendar = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.preferredDatePickerStyle = .inline
        calendar.datePickerMode = .date
        calendar.tintColor = .primary
        view.addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
    }
    
}
