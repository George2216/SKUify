//
//  COGVC.swift
//  SKUify
//
//  Created by George Churikov on 29.03.2024.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class COGVC: BaseViewController {
    
    var viewModel: COGViewModel!
    private let textField = DefaultTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "COG"
        
        textField.config = .init(style: .doubleBordered("$"), textObserver: { text in
//            print(text)
        })
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY
                .equalToSuperview()
            make.horizontalEdges
                .equalToSuperview()
                .inset(30)
        }
        
        let button = DefaultButton()
        button.config = .init(title: "Filter", style: .popover, action: {
            
        })
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
}

