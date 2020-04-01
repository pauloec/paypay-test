//
//  Configuration.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation

enum Environment: String {
    case Sandbox = "Sandbox"

    var currencyKey: String {
        switch self {
        default:
            return "1d9c0ba0740cda7ee786a88714087085"
        }
    }
    
    var queryAccess: URLQueryItem {
        return URLQueryItem(name: "access_key", value: currencyKey)
    }
}

class Configuration {
    lazy var environment: Environment = {
        return Environment.Sandbox
    }()
}
