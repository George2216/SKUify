//
//  NetworkProvider.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation

public protocol NetworkProvider {
    func makeLoginNetwork() -> LoginNetwork
    func makeChartsNetwork() -> ChartsNetwork
    func makeUserDataNetwork() -> UserDataNetwork
    func makeSalesRefundsNetwork() -> SalesRefundsNetwork
    func makeSalesOrdersNetwork() -> SalesOrdersNetwork
    func makeInventoryOrdersNetwork() -> InventoryOrdersNetwork
    func makeInventoryBuyBotImportsNetwork() -> InventoryBuyBotImportsNetwork
    func makeNoteInventoryNetwork() -> NoteNetwork
    func makeNoteSalesNetwork() -> NoteNetwork

}

