//
//  ChartNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 20.12.2023.
//

import Foundation
import Domain
import RxSwift
import Alamofire

final class ChartsNetwork: Domain.ChartsNetwork {
    
    private let network: Network<ChartMainDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    private let commonInterceptor: CompositeRxAlamofireInterceptor
    
    init(
        network: Network<ChartMainDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
        self.commonInterceptor = CompositeRxAlamofireInterceptor(
            interceptors: [
                interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                interceptorFactory.makeTokenToHeaderInterceptor(),
                interceptorFactory.makeUserIdToParametersInterceptor()
            ]
        )
    }
    
    private func getPath(
        _ period: String,
        _ startDate: String = "",
        _ endDate: String = ""
    ) -> String {
        return "chart/?period=\(period)&start_date=\(startDate)&end_date=\(endDate)&marketplace=all_marketplaces&/"
    }
    
    private func makeChartsRequest(
        _ path: String,
        _ method: HTTPMethod
    ) -> Observable<ChartMainDTO> {
        return network.request(
            path,
            method: method,
            interceptor: commonInterceptor
        )
    }
    
    func chartsToday(_ startDate: String) -> Observable<ChartMainDTO> {
        return makeChartsRequest(
            getPath(
                "today",
                startDate
            ),
            .get
        )
    }
    
    func chartsYesterday(_ startDate: String) -> Observable<ChartMainDTO> {
        return makeChartsRequest(
            getPath(
                "yesterday",
                startDate
            ),
            .get
        )
    }
    
    func chartsWeek(_ startDate: String) -> Observable<ChartMainDTO> {
        return makeChartsRequest(
            getPath(
                "week",
                startDate
            ),
            .get
        )
    }
    
    func chartsMonth(_ startDate: String) -> Observable<ChartMainDTO> {
        return makeChartsRequest(
            getPath("month",
                    startDate
                   ),
            .get
        )
    }
    
    func chartsQuarter(_ startDate: String) -> Observable<ChartMainDTO> {
        return makeChartsRequest(
            getPath(
                "quarter",
                startDate
            ),
            .get
        )
    }
    
    func chartsYear(_ startDate: String) -> Observable<ChartMainDTO> {
        return makeChartsRequest(
            getPath(
                "year",
                startDate
            ),
            .get
        )
    }
    
    func chartsAll() -> Observable<ChartMainDTO> {
        return makeChartsRequest(
            getPath("all"),
            .get
        )
    }
    
    func chartsCustom(
        _ startDate: String,
        _ endDate: String
    ) -> Observable<ChartMainDTO> {
        return makeChartsRequest(
            getPath(
                "custom",
                startDate,
                endDate
            ),
            .get
        )
    }
    
}
