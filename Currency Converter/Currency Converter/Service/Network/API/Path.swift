//
//  Path.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation

struct Path {
    private static let apiPath = URL(string: "http://api.currencylayer.com/")!

    struct Currency {
        static let rate = apiPath.appendingPathComponent("live")
        static let list = apiPath.appendingPathComponent("list")
    }
}
