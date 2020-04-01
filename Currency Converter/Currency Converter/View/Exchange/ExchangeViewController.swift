//
//  ExchangeViewController.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import UIKit
import Combine

class ExchangeViewController: UIViewController, ViewType {    
    typealias ViewModel = ExchangeVCViewModel
    private var viewModel: ViewModel!
    private var disposables = Set<AnyCancellable>()
    
    private var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .white
            tableView.rowHeight = 50
            tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            tableView.register(ExchangeItemCell.self, forCellReuseIdentifier: currencyCellIdentifier)
        }
    }
    
    private let currencyCellIdentifier: String = "currencyCellIdentifier"
    
    private var currencyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Select Currency", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    private let currencyTextField: CurrencyField = {
        let textField = CurrencyField()
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.backgroundColor = .white
        textField.text = "0"
        return textField
    }()
    
    private var loaderView: UIActivityIndicatorView = {
        let loaderView = UIActivityIndicatorView(style: .large)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        return loaderView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        title = "Currency Converter"
        navigationItem.largeTitleDisplayMode = .never

        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshCurrencies))
        navigationItem.leftBarButtonItem = refreshItem
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        currencyButton.addTarget(self, action: #selector(tapCurrency), for: .touchUpInside)
        currencyTextField.addTarget(self, action: #selector(currencyFieldChanged), for: .editingChanged)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        
        [currencyButton, currencyTextField, tableView, loaderView].forEach {
            view.addSubview($0)
        }

        currencyButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.leadingAnchor,
                              bottom: nil,
                              trailing: view.trailingAnchor,
                              padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10),
                              size: CGSize(width: 0, height: 40))
        currencyTextField.anchor(top: currencyButton.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: nil,
                              trailing: view.trailingAnchor,
                              padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10),
                              size: CGSize(width: 0, height: 40))
        tableView.anchor(top: currencyTextField.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: view.trailingAnchor,
                         padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        loaderView.anchorToCenter()
    }
    
    @objc func refreshCurrencies() {
        viewModel.input.tapRefresh.send()
    }
    
    @objc func tapCurrency() {
        viewModel.input.tapCurrency.send()
    }
    
    @objc func currencyFieldChanged() {
        guard viewModel != nil else { return }
        viewModel.input.changeAmount.send(currencyTextField.doubleValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    func configure(withViewModel viewModel: ViewModel) {
        self.viewModel = viewModel
        
        viewModel.input.tapRefresh.send()
        
        viewModel.output.items
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &disposables)
        
        viewModel.output.isLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                if isLoading {
                    self?.loaderView.startAnimating()
                } else {
                    self?.loaderView.stopAnimating()
                }
            })
            .store(in: &disposables)
        
        viewModel.output.currencyTitle
            .sink(receiveValue: { [weak self] title in
                self?.currencyButton.setTitle(title, for: .normal)
            })
            .store(in: &disposables)
    }
}
    
extension ExchangeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: currencyCellIdentifier, for: indexPath) as! ExchangeItemCell
        cell.configure(withViewModel: viewModel.output.items.value[indexPath.row])
        return cell
    }
}
