//
//  CommonAlertVC.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import Foundation
import UIKit
import SnapKit

final class CommonAlertVC: BaseAlertVC {
    
    private lazy var alertView = CommonAlertView()
    
    convenience init(_ input: CommonAlertView.Input) {
        self.init(nibName: nil, bundle: nil)
        alertView.setupInput(input)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlertView()
    }
    
    private func setupAlertView() {
        alertView.delegate = self
        
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.centerY
                .equalToSuperview()
            make.horizontalEdges
                .equalToSuperview()
                .inset(20)
        }
    }
    
}
