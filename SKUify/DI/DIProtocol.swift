//
//  DIProtocol.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation

protocol DIProtocol:
    AppManagerUseCases,
    AuthenticationUseCases,
    DashboardUseCases,
    SalesUseCases,
    ExpensesUseCases,
    InventoryUseCases,
    SettingsUseCases,
    ProfileUseCases,
    CompanyInformationUseCases,
    NoteAlertUseCases,
    COGUseCases,
    COGSettingsUseCases,
    ExpenseTransactionsUseCases,
    SubscriptionUseCase
{}
