//
//  CurrencyModel.swift
//  Currency Converter
//
//  Created by Paulo Correa on 20/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation

struct CurrencyModel: Codable, Comparable {
    let name: String
    let code: String
    let rate: Double
    
    static func < (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
        return lhs.name < rhs.name
    }
}
