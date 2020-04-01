//
//  ExchangeCurrencyItem.swift
//  Currency Converter
//
//  Created by Paulo Correa on 20/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation
import Combine

class ExchangeItemViewModel: ViewModelType {
    struct Input {
        let amountToExchange: PassthroughSubject<Double, Never>
    }
    
    struct Output {
        let name: String
        let value: CurrentValueSubject<String, Never>
    }
    
    let input: Input
    let output: Output
    
    private let amountToExchangeSubject = PassthroughSubject<Double, Never>()
    private let valueSubject = CurrentValueSubject<String, Never>("")
    private var disposables = Set<AnyCancellable>()
    
    init(withCurrency currency: CurrencyModel) {
        let currencyTitle = currency.name + " - " + currency.code
        
        input = Input(amountToExchange: amountToExchangeSubject)
        output = Output(name: currencyTitle,
                        value: valueSubject)
        
        amountToExchangeSubject
            .sink(receiveValue: { [weak self] amount in
                self?.valueSubject.send(String(format:"%.2f", currency.rate * amount))
            })
            .store(in: &disposables)
    }
}
