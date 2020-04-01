//
//  ViewModelType.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import Foundation

protocol ViewModelType: class {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
