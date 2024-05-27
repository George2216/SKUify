//
//  SimpleTablePopoverVC.swift
//  SKUify
//
//  Created by George Churikov on 20.05.2024.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleTablePopoverVC: UIViewController {
    private var disposeBag = DisposeBag()

    // MARK: - UI elements
    
    private let tableView = SimpleTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
// We use a cloger as it is much more convenient to process in viewModel
    func build(_ input: PopoverInput<Int, String>) -> Self {
        disposeBag = DisposeBag()
        
        tableView.bind(.just(input.content))
            .disposed(by: disposeBag)
        
        tableView.select(at: input.startValue ?? 0)
        
        tableView
            .subscribeOnRowSelected()
            .withUnretained(self)
            .drive(onNext: { owner, row in
                input.observer(row)
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        return self
    }
    
    // MARK: - Privete methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

// MARK: - Input

extension SimpleTablePopoverVC {
    
    struct Input {
        let titles: [String]
        let selectedItem: Int?
        let itemSelected: (Int) -> Void
    }

}
