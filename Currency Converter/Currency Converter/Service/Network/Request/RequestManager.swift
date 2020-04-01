//
//  RequestManager.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation
import Combine

struct RequestManager {
    struct Response<Element> {
        let content: Element
        let response: URLResponse
    }
    
    static func request<Element: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<Element>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { result -> Response<Element> in
                let content = try decoder.decode(Element.self, from: result.data)
                return Response(content: content, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
