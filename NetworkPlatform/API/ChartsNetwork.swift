//
//  ChartNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 20.12.2023.
//

import Foundation
import Domain
import RxSwift

final class ChartsNetwork: Domain.ChartsNetwork {
   
    private let network: Network<ChartMainDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<ChartMainDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    private func getPath(
        _ period: String,
        _ startDate: String = "",
        _ endDate: String = ""
    ) -> String {
       return  "/chart/?period=\(period)&start_date=\(startDate)&end_date=\(endDate)&marketplace=all_marketplaces&/&debug_user_id=1"
    }
    
    func chartsToday(_ startDate: String) -> Observable<ChartMainDTO> {
        return network.request(
            getPath(
                "today",
                startDate
            ),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
    func chartsYesterday(_ startDate: String) -> Observable<ChartMainDTO> {
        return network.request(
            getPath(
                "yesterday",
                startDate
            ),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
    func chartsWeek(_ startDate: String) -> Observable<ChartMainDTO> {
        return network.request(
            getPath(
                "week",
                startDate
            ),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
    func chartsMonth(_ startDate: String) -> Observable<ChartMainDTO> {
        return network.request(
            getPath(
                "month",
                startDate
            ),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
    func chartsQuarter(_ startDate: String) -> Observable<ChartMainDTO> {
        return network.request(
            getPath(
                "quarter",
                startDate
            ),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
    func chartsYear(_ startDate: String) -> Observable<ChartMainDTO> {
        return network.request(
            getPath(
                "year",
                startDate
            ),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
    func chartsAll() -> Observable<ChartMainDTO> {
        return network.request(
            getPath(
                "all"
            ),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
    func chartsCustom(
        _ startDate: String,
        _ endDate: String
    ) -> Observable<ChartMainDTO> {
        return network.request(
            getPath(
                "custom",
                startDate,
                endDate
            ),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    

}
