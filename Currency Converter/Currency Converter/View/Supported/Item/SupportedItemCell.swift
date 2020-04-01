//
//  SupportedItemCell.swift
//  Currency Converter
//
//  Created by Paulo Correa on 23/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import UIKit
import Combine

class SupportedItemCell: UITableViewCell, ViewType {
    typealias ViewModel = SupportedItemViewModel
    private var viewModel: ViewModel!
    private var disposables = Set<AnyCancellable>()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    func configure(withViewModel viewModel: ViewModel) {
        self.viewModel = viewModel
        textLabel?.text = viewModel.output.name
    }
}
