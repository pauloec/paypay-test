//
//  ExchangeItemCell.swift
//  Currency Converter
//
//  Created by Paulo Correa on 20/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import UIKit
import Combine

class ExchangeItemCell: UITableViewCell, ViewType {
    typealias ViewModel = ExchangeItemViewModel
    private var viewModel: ViewModel!
    private var disposables = Set<AnyCancellable>()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    func configure(withViewModel viewModel: ViewModel) {
        self.viewModel = viewModel
        
        textLabel?.text = viewModel.output.name
        viewModel.output.value
            .sink(receiveValue: { [weak self] amount in
                self?.detailTextLabel?.text = amount
            })
            .store(in: &disposables)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposables = Set<AnyCancellable>()
    }
}
