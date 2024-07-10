//
//  NetworkProvider.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation

public protocol NetworkProvider {
    func makeLoginNetwork() -> LoginNetwork
    func makeSubscriptionsNetwork() -> SubscriptionsNetwork
    func makeUpdatePasswordNetwork() -> UpdatePasswordNetwork
    func makeResetPasswordNetwork() -> ResetPasswordNetwork
    func makeChartsNetwork() -> ChartsNetwork
    func makeUserDataNetwork() -> UserDataNetwork
    func makeSalesRefundsNetwork() -> SalesRefundsNetwork
    func makeSalesOrdersNetwork() -> SalesOrdersNetwork
    func makeInventoryOrdersNetwork() -> InventoryOrdersNetwork
    func makeInventoryBuyBotImportsNetwork() -> InventoryBuyBotImportsNetwork
    func makeNoteInventoryNetwork() -> NoteNetwork
    func makeNoteSalesNetwork() -> NoteNetwork
    func makeSalesBreakEvenPointNetwork() -> BreakEvenPointNetwork
    func makeNotificationsNetwork() -> NotificationsNetwork
    func makeInventoryBreakEvenPointNetwork() -> BreakEvenPointNetwork
    func makeCOGSalesNetwork() -> COGSalesNetwork
    func makeCOGInventoryNetwork() -> COGInventoryNetwork
    func makeReplenishCOGNetwork() -> ReplenishCOGNetwork
    func makeCOGSInformationNetwork() -> COGSInformationNetwork
    func makeCOGBbpImoprtStategyNetwork() -> COGBbpImoprtStategyNetwork
    func makeCOGSettingsNetwork() -> COGSettingsNetwork
    func makeExpensesNetwork() -> ExpensesNetwork
    func makeUpdateExpensesNetwork() -> UpdateExpensesNetwork
    func makeExpensesCategoriesNetwork() -> ExpensesCategoriesNetwork
}

