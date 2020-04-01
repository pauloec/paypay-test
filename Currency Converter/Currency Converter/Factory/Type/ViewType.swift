//
//  ViewType.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import UIKit

protocol ViewType: class {
    associatedtype ViewModel: ViewModelType
    func configure(withViewModel viewModel: ViewModel)
}
