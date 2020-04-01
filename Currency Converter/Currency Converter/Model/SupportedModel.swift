//
//  SupportedModel.swift
//  Currency Converter
//
//  Created by Paulo Correa on 20/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation

struct SupportedModel: Codable {
    let terms: URL
    let privacy: URL
    let currencies: [String: String]
}
