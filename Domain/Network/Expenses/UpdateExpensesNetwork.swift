//
//  UpdateExpensesNetwork.swift
//  Domain
//
//  Created by George Churikov on 21.05.2024.
//

import Foundation
import RxSwift

public protocol UpdateExpensesNetwork {
    func updateExpenses(_ expenses: [ExpenseDTO]) -> Observable<[ExpenseDTO]>
}
