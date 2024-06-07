//
//  NotificationsVC.swift
//  SKUify
//
//  Created by George Churikov on 07.06.2024.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class NotificationsVC: BaseViewController {
    
    var viewModel: NotificationsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
    }
    
}

