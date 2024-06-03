//
//  ExpenseTransactionsVC.swift
//  SKUify
//
//  Created by George Churikov on 31.05.2024.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ExpenseTransactionsVC: BaseViewController {
    
    var viewModel: ExpenseTransactionsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.transform(.init())
        bindToTitle(output)
    }
    
}

// MARK: - Make binding

extension ExpenseTransactionsVC {
    
    private func bindToTitle(_ output: ExpenseTransactionsViewModel.Output) {
        output.title
            .drive(rx.title)
            .disposed(by: disposeBag)
    }
}
