//
//  ApplicationCoordinator.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import UIKit
import Combine

class ApplicationCoordinator: CoordinatorType {
    private let window: UIWindow
    private var exchangeCoordinator: ExchangeCoordinator?
    
    init(withWindow window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let naviationController = UINavigationController()
        naviationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = naviationController
        window.makeKeyAndVisible()
        
        let exchangeCoordinator = ExchangeCoordinator(presenter: naviationController)
        exchangeCoordinator.start()

        self.exchangeCoordinator = exchangeCoordinator
    }
}
