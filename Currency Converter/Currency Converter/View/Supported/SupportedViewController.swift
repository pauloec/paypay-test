//
//  SupportedViewController.swift
//  Currency Converter
//
//  Created by Paulo Correa on 22/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import UIKit
import Combine

class SupportedViewController: UIViewController, ViewType {
    typealias ViewModel = SupportedVCViewModel
    private var viewModel: ViewModel!
    private var disposables = Set<AnyCancellable>()

    private var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .white
            tableView.rowHeight = 50
            tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            tableView.register(SupportedItemCell.self, forCellReuseIdentifier: currencyCellIdentifier)
        }
    }

    private let currencyCellIdentifier: String = "currencyCellIdentifier"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        title = "Select Currency"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupLayout() {        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        [tableView].forEach {
            view.addSubview($0)
        }

        tableView.anchorSuperview()
    }
    
    func configure(withViewModel viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

extension SupportedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: currencyCellIdentifier, for: indexPath) as! SupportedItemCell
        cell.configure(withViewModel: viewModel.output.items.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.selectedCurrency.send(indexPath.row)
    }
}
