//
//  CurrencyModel.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation

struct RateModel: Codable {
    let terms: URL
    let privacy: URL
    let timestamp: Date
    let source: String
    let quotes: [String: Double]
}
