//
//  SupportedCoordinator.swift
//  Currency Converter
//
//  Created by Paulo Correa on 22/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import UIKit
import Combine

class SupportedCoordinator: CoordinatorType {
    private let presenter: UINavigationController
    private let supportedViewModel: SupportedVCViewModel
    private let supportedViewController: SupportedViewController
    private var rootViewController: UIViewController {
        return supportedViewController
    }
    
    init(presenter: UINavigationController, onSelectCurrency selectCurrency: @escaping (CurrencyModel) -> Void) {
        let supportedViewModel = SupportedVCViewModel(withCurrencies: CurrencyDefaults.currencies,
                                                      onSelectCurrency: selectCurrency)
        let supportedViewController = SupportedViewController()
        supportedViewController.configure(withViewModel: supportedViewModel)
        
        self.presenter = presenter
        self.supportedViewModel = supportedViewModel
        self.supportedViewController = supportedViewController
    }
    
    func start() {
        presenter.pushViewController(rootViewController, animated: true)
    }
}
