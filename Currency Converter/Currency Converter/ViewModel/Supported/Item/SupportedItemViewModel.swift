//
//  SupportedItemCell.swift
//  Currency Converter
//
//  Created by Paulo Correa on 23/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation
import Combine

class SupportedItemViewModel: ViewModelType {
    struct Input {
        
    }
    struct Output {
        let name: String
    }
    
    let input: Input
    let output: Output
        
    init(withCurrency currency: CurrencyModel) {
        let currencyTitle = currency.name + " - " + currency.code
        
        input = Input()
        output = Output(name: currencyTitle)
    }
}
