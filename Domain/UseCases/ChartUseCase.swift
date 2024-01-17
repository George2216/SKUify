//
//  ChartUseCase.swift
//  Domain
//
//  Created by George Churikov on 23.12.2023.
//

import Foundation
import RxSwift

public protocol ChartsUseCase {
    func chartsToday(_ startDate: String) -> Observable<ChartMainDTO>
    func chartsYesterday(_ startDate: String) -> Observable<ChartMainDTO>
    func chartsWeek(_ startDate: String) -> Observable<ChartMainDTO>
    func chartsMonth(_ startDate: String) -> Observable<ChartMainDTO>
    func chartsQuarter(_ startDate: String) -> Observable<ChartMainDTO>
    func chartsYear(_ startDate: String) -> Observable<ChartMainDTO>
    func chartsAll() -> Observable<ChartMainDTO>
    func chartsCustom(
        _ startDate: String,
        _ endDate: String
    ) -> Observable<ChartMainDTO>
}
