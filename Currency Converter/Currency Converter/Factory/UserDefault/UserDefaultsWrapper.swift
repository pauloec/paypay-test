//
//  UserDefaultWrapper.swift
//  Currency Converter
//
//  Created by Paulo Correa on 20/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<Element: Codable> {
    let key: String
    let defaultValue: Element
    let userDefaults: UserDefaults = .standard
    
    var wrappedValue: Element {
        get {
            guard let jsonString = userDefaults.string(forKey: key) else {
                return defaultValue
            }
            
            guard let jsonData = jsonString.data(using: .utf8) else {
                return defaultValue
            }
            
            guard let value = try? JSONDecoder().decode(Element.self, from: jsonData) else {
                return defaultValue
            }
            
            return value
        }
        set {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            guard let jsonData = try? encoder.encode(newValue) else { return }
            
            let jsonString = String(bytes: jsonData, encoding: .utf8)
            userDefaults.set(jsonString, forKey: key)
        }
    }
}

struct CurrencyDefaults {
    @UserDefaultsWrapper(key: "com.currency.timestamp",
                         defaultValue: Date(timeIntervalSince1970: 0))
    static var timestamp: Date
    
    @UserDefaultsWrapper(key: "com.currency.list",
                         defaultValue: [])
    static var currencies: [CurrencyModel]
    
    @UserDefaultsWrapper(key: "com.currency.selected",
                         defaultValue: nil)
    static var selectedCurrency: CurrencyModel?
}
