//
//  BalanceViewController.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 06.01.26.
//

import UIKit
import SwiftUI
import Combine

final class BalanceViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    private let account: AccountModel
    private let viewModel: BalanceViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private var chartHostingController: UIHostingController<ChartView>?
    private var transactionsHostingController: UIHostingController<TransactionsView>?
    private let aiOverviewCard = AIOverviewCard()
    private let chartViewModel: ChartViewModel
    
    private let onBack: () -> Void
    private let onExchange: () -> Void
    
    private let balanceView = BalanceView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let whiteSafeAreaView = UIView()
    
    // MARK: - Initializers
    init(
        account: AccountModel,
        viewModel: BalanceViewModel,
        chartViewModel: ChartViewModel,
        onBack: @escaping () -> Void,
        onExchange: @escaping () -> Void
    ) {
        self.account = account
        self.viewModel = viewModel
        self.chartViewModel = chartViewModel
        self.onBack = onBack
        self.onExchange = onExchange
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "SecondaryBackground")
        
        setupNavigation()
        setupScrollView()
        setupBalanceView()
        setupWhiteSafeAreaView()
        setupChart()
        setupAIOverviewCard()
        setupTransactionsView()
        bindViewModel()
        viewModel.loadTransactions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
    
    // MARK: - Setup UI
    
    private func setupNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = account.name
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBack)
        )
        navigationItem.leftBarButtonItem = backButton

        let exchangeButton = UIBarButtonItem(
            image: UIImage(systemName: "creditcard.arrow.trianglehead.2.clockwise.rotate.90"),
            style: .plain,
            target: self,
            action: #selector(handleExchange)
        )
        navigationItem.rightBarButtonItem = exchangeButton

    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func setupBalanceView() {
        contentView.addSubview(balanceView)
                
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            balanceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            balanceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            balanceView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func setupChart() {
        let chartView = ChartView(viewModel: chartViewModel)
        let hosting = UIHostingController(rootView: chartView)
        chartHostingController = hosting

        addChild(hosting)
        contentView.addSubview(hosting.view)

        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        hosting.view.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: 8),
            hosting.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hosting.view.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])

        hosting.didMove(toParent: self)
    }
    
    private func setupAIOverviewCard() {
        contentView.addSubview(aiOverviewCard)
        aiOverviewCard.translatesAutoresizingMaskIntoConstraints = false
        aiOverviewCard.isHidden = true

        guard let chartView = chartHostingController?.view else { return }

        NSLayoutConstraint.activate([
            aiOverviewCard.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 8),
            aiOverviewCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            aiOverviewCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            aiOverviewCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func setupTransactionsView() {
        let transactionsView = TransactionsView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: transactionsView)
        transactionsHostingController = hosting

        addChild(hosting)
        view.addSubview(hosting.view)

        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        hosting.view.backgroundColor = .clear
        hosting.view.isUserInteractionEnabled = true

        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hosting.didMove(toParent: self)

        scrollView.contentInset.bottom = 80
        scrollView.verticalScrollIndicatorInsets.bottom = 80
    }

    private func setupWhiteSafeAreaView() {
        contentView.addSubview(whiteSafeAreaView)
        
        whiteSafeAreaView.backgroundColor = UIColor(named: "Background")
        
        whiteSafeAreaView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            whiteSafeAreaView.topAnchor.constraint(equalTo: view.topAnchor),
            whiteSafeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteSafeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteSafeAreaView.bottomAnchor.constraint(equalTo: balanceView.topAnchor)
        ])
    }
    
    // MARK: - Bindings
    
    private func bindViewModel() {
        
        Publishers.CombineLatest(viewModel.$balance, viewModel.$currencySymbol)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance, symbol in
                guard let self else { return }
                self.balanceView.updateBalance(
                    balance: balance,
                    currency: symbol
                )
            }
            .store(in: &cancellables)
        
        viewModel.$transactions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transactions in
                guard let self else { return }
                self.chartViewModel.reload(with: transactions)
            }
            .store(in: &cancellables)

        Publishers.CombineLatest(viewModel.$balance, viewModel.$transactions)
            .dropFirst()            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance, transactions in
                guard let self else { return }
                self.refreshAIOverview(balance: balance, transactions: transactions)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Functions
    
    @objc private func handleBack() {
        onBack()
    }
    
    @objc private func handleExchange() {
        onExchange()
    }

    private func refreshAIOverview(balance: Double, transactions: [Transaction]) {
        aiOverviewCard.generate(
            accountName: account.name,
            currency: account.currency,
            balance: balance,
            transactions: transactions
        )
    }
}

