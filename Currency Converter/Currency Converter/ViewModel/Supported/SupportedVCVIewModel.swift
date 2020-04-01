//
//  SupportedCoordinator.swift
//  Currency Converter
//
//  Created by Paulo Correa on 22/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation
import Combine

class SupportedVCViewModel: ViewModelType {
    struct Input {
        let selectedCurrency: PassthroughSubject<Int, Never>
    }
    struct Output {
        let isLoading: CurrentValueSubject<Bool, Never>
        let items: CurrentValueSubject<[SupportedItemViewModel], Never>
    }
    
    let input: Input
    let output: Output
    
    private let selectedCurrencySubject = PassthroughSubject<Int, Never>()
    
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private var itemsSubject: CurrentValueSubject<[SupportedItemViewModel], Never>
    private var disposables = Set<AnyCancellable>()

    init(withCurrencies currencies: [CurrencyModel],
         onSelectCurrency selectCurrency: @escaping (CurrencyModel) -> Void) {
        let supportedItems = currencies.map { currency in
            SupportedItemViewModel(withCurrency: currency)
        }
        itemsSubject = CurrentValueSubject<[SupportedItemViewModel], Never>(supportedItems)
        
        input = Input(selectedCurrency: selectedCurrencySubject)
        output = Output(isLoading: isLoadingSubject,
                        items: itemsSubject)
        
        selectedCurrencySubject
            .sink(receiveValue: { index in
                selectCurrency(currencies[index])
            })
            .store(in: &disposables)
    }
}
