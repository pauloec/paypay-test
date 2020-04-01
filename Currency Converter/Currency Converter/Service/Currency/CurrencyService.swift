//
//  CurrencyService.swift
//  Currency Converter
//
//  Created by Paulo Correa on 20/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation
import Combine

struct CurrencyService {
    static func getCurrencies() -> AnyPublisher<[CurrencyModel], Error> {
        let calendar = Calendar.current
        let timeNow = Date()
        let differenceMinutes = calendar.dateComponents([.minute], from: CurrencyDefaults.timestamp, to: timeNow)
        
        guard let minutes = differenceMinutes.minute, minutes < 30 else {
            return requestCurrencies()
        }
        
        return loadCurrencies()
    }
    
    private static func loadCurrencies() -> AnyPublisher<[CurrencyModel], Error> {
        Result.Publisher(CurrencyDefaults.currencies)
            .eraseToAnyPublisher()
    }
    
    private static func requestCurrencies() -> AnyPublisher<[CurrencyModel], Error> {
        Publishers.CombineLatest(getRateCurrency(), getSupportedCurrency())
            .map { rate, supported in
                let currencies = supported.currencies.map { supportedCurrency in
                    CurrencyModel(name: supportedCurrency.value,
                                  code: supportedCurrency.key,
                                  rate: rate.quotes[rate.source+supportedCurrency.key] ?? 0)
                }.sorted()

                saveCurrencies(currencies)
                
                return currencies
            }
            .eraseToAnyPublisher()
    }
    
    static func saveSelectedCurrency(_ currency: CurrencyModel) -> Void {
        CurrencyDefaults.selectedCurrency = currency
    }
    
    private static func getSelectedCurrency() -> CurrencyModel? {
        return CurrencyDefaults.selectedCurrency
    }
    
    private static func getSavedCurrencies() -> [CurrencyModel] {
        return CurrencyDefaults.currencies
    }
    
    private static func saveCurrencies(_ currencies: [CurrencyModel]) {
        CurrencyDefaults.currencies = currencies
        CurrencyDefaults.timestamp = Date()
    }
    
    private static func getSupportedCurrency() -> AnyPublisher<SupportedModel, Error> {
        return NetworkService.getSupportedCurriencies()
    }
    
    private static func getRateCurrency() -> AnyPublisher<RateModel, Error> {
        return NetworkService.getRateCurriencies()
    }
}
