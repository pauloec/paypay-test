//
//  NetworkService.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation
import Combine

enum NetworkService {
    static let requestManager = RequestManager()
}

extension NetworkService {
    static func getSupportedCurriencies() -> AnyPublisher<SupportedModel, Error> {
        var requestComponents = URLComponents(url: Path.Currency.list, resolvingAgainstBaseURL: false)!
        let requestQuery = Configuration().environment.queryAccess
        requestComponents.queryItems = [requestQuery]
        
        let request = URLRequest(url: requestComponents.url!)
        
        return RequestManager.request(request)
            .map { $0.content }
            .eraseToAnyPublisher()
    }
    
    static func getRateCurriencies() -> AnyPublisher<RateModel, Error> {
        var requestComponents = URLComponents(url: Path.Currency.rate, resolvingAgainstBaseURL: false)!
        let requestQuery = Configuration().environment.queryAccess
        requestComponents.queryItems = [requestQuery]
        
        let request = URLRequest(url: requestComponents.url!)
        
        return RequestManager.request(request)
            .map { $0.content }
            .eraseToAnyPublisher()
    }
}
