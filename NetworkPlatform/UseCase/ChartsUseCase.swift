//
//  ChartsUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 22.12.2023.
//

import Foundation
import Domain
import RxSwift

final class ChartsUseCase: Domain.ChartsUseCase {
   
    private let network: Domain.ChartsNetwork

    init(network: Domain.ChartsNetwork) {
        self.network = network
    }
    
    func chartsToday(_ startDate: String) -> Observable<ChartMainDTO> {
        network.chartsToday(startDate)
    }
    
    func chartsYesterday(_ startDate: String) -> Observable<ChartMainDTO> {
        network.chartsYesterday(startDate)
    }
    
    func chartsWeek(_ startDate: String) -> Observable<ChartMainDTO> {
        network.chartsWeek(startDate)
    }
    
    func chartsMonth(_ startDate: String) -> Observable<ChartMainDTO> {
        network.chartsMonth(startDate)
    }
    
    func chartsQuarter(_ startDate: String) -> Observable<ChartMainDTO> {
        network.chartsQuarter(startDate)
    }
    
    func chartsYear(_ startDate: String) -> Observable<ChartMainDTO> {
        network.chartsYear(startDate)
    }
    
    func chartsAll() -> Observable<ChartMainDTO> {
        network.chartsAll()
    }
    
    func chartsCustom(
        _ startDate: String,
        _ endDate: String)
    -> Observable<ChartMainDTO> {
        network.chartsCustom(
            startDate,
            endDate
        )
    }
    
}
