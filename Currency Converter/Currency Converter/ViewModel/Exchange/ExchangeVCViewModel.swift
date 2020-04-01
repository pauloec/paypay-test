//
//  ExchangeVCViewModel.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation
import Combine

class ExchangeVCViewModel: ViewModelType {
    struct Input {
        let tapRefresh: PassthroughSubject<Void, Error>
        let changeAmount: PassthroughSubject<Double, Never>
        let selectCurrency: PassthroughSubject<CurrencyModel, Never>
        let tapCurrency: PassthroughSubject<Void, Never>
    }
    struct Output {
        let currencyTitle: CurrentValueSubject<String, Never>
        let isLoading: CurrentValueSubject<Bool, Never>
        let items: CurrentValueSubject<[ExchangeItemViewModel], Never>
        let shouldOpenSupportedList: PassthroughSubject<Void, Never>
    }
    
    let input: Input
    let output: Output
    
    private let tapRefreshSubject = PassthroughSubject<Void, Error>()
    private let changeAmountSubject = PassthroughSubject<Double, Never>()
    private let selectCurrencySubject = PassthroughSubject<CurrencyModel, Never>()
    private let tapCurrencySubject = PassthroughSubject<Void, Never>()
    
    private let currencyTitleSubject = CurrentValueSubject<String, Never>("Select Currency")
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private var itemsSubject = CurrentValueSubject<[ExchangeItemViewModel], Never>([])
    private let shouldOpenSupportedListSubject = PassthroughSubject<Void, Never>()
        
    private var disposables = Set<AnyCancellable>()

    init() {
        input = Input(tapRefresh: tapRefreshSubject,
                      changeAmount: changeAmountSubject,
                      selectCurrency: selectCurrencySubject,
                      tapCurrency: tapCurrencySubject)
        output = Output(currencyTitle: currencyTitleSubject,
                        isLoading: isLoadingSubject,
                        items: itemsSubject,
                        shouldOpenSupportedList: shouldOpenSupportedListSubject)
       
        tapRefreshSubject
            .flatMap { [unowned self] _ in
                self.getCurrencies()
            }
            .map { [unowned self] currencies in
                self.getItems(from: currencies)
            }
            .sink(receiveCompletion: { result in
                self.isLoadingSubject.send(false)

                switch result {
                case .failure(_):
                    print("track/assert/handle error")
                default:
                    break
                }
            }, receiveValue: { [unowned self] items in
                self.itemsSubject.send(items)
                self.isLoadingSubject.send(false)
            })
            .store(in: &disposables)
                
        changeAmountSubject
            .combineLatest(selectCurrencySubject)
            .sink(receiveValue: { [unowned self] amount, currency in                
                self.updateRates(amount)
            })
            .store(in: &disposables)

        selectCurrencySubject
            .sink(receiveValue: { [unowned self] currency in
                self.currencyTitleSubject.send(currency.name)
            })
            .store(in: &disposables)
        
        tapCurrencySubject
            .sink(receiveValue: { [unowned self] _ in
                self.shouldOpenSupportedListSubject.send()
            })
            .store(in: &disposables)
        
        if let selectedCurrency = CurrencyDefaults.selectedCurrency {
            selectCurrencySubject.send(selectedCurrency)
        }
    }
    
    private func updateRates(_ amount: Double) {
        guard let selectedCurrency = CurrencyDefaults.selectedCurrency else { return }
        let amountUSD = amount / selectedCurrency.rate
        
        for item in itemsSubject.value {
            item.input.amountToExchange.send(amountUSD)
        }
    }
    
    private func getItems(from currencies: [CurrencyModel]) -> [ExchangeItemViewModel] {
        return currencies.map { currency in
            ExchangeItemViewModel(withCurrency: currency)
        }
    }
    
    private func getCurrencies() -> AnyPublisher<[CurrencyModel], Error> {
        isLoadingSubject.send(true)
        itemsSubject.send([])
        
        return CurrencyService.getCurrencies()
    }
}
