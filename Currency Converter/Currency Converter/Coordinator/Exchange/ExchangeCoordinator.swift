//
//  ExchangeCoordinator.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import UIKit
import Combine

class ExchangeCoordinator: CoordinatorType {
    private let presenter: UINavigationController
    private let exchangeViewModel: ExchangeVCViewModel
    private let exchangeViewController: ExchangeViewController
    private var supportedCoordinator: SupportedCoordinator?
    private var disposables = Set<AnyCancellable>()

    private var rootViewController: UIViewController {
        return exchangeViewController
    }
    
    init(presenter: UINavigationController) {
        let exchangeViewModel = ExchangeVCViewModel()
        let exchangeViewController = ExchangeViewController()
        exchangeViewController.configure(withViewModel: exchangeViewModel)
        
        self.presenter = presenter
        self.exchangeViewModel = exchangeViewModel
        self.exchangeViewController = exchangeViewController
        
        exchangeViewModel.output.shouldOpenSupportedList
            .sink(receiveValue: { [unowned self] _ in
                self.pushSupportedList()
            })
            .store(in: &disposables)
    }
    
    func pushSupportedList() {
        if let supportedCoordinator = supportedCoordinator {
            supportedCoordinator.start()
        } else {
            let selectCurrency: (CurrencyModel) -> Void = { [unowned self] currency in
                CurrencyService.saveSelectedCurrency(currency)
                self.exchangeViewModel.input.selectCurrency.send(currency)
                self.presenter.popViewController(animated: true)
            }
            
            let supportedCoordinator = SupportedCoordinator(presenter: presenter,
                                                            onSelectCurrency: selectCurrency)
            self.supportedCoordinator = supportedCoordinator
            supportedCoordinator.start()
        }
    }
    
    func start() {
        presenter.pushViewController(rootViewController, animated: false)
    }
}
