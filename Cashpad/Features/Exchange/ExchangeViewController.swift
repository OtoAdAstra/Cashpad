//
//  ExchangeViewController.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 21.01.26.
//

import UIKit
import Combine

final class ExchangeViewController: UIViewController, UITextFieldDelegate {

    private let viewModel: ExchangeViewModel
    private let cardView = ExchangeCardView()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ExchangeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        title = "Exchange"

        setupNavigation()
        setupLayout()
        setupActions()
        bindViewModel()
        setupTextFields()

        if let popGesture = navigationController?.interactivePopGestureRecognizer {
            popGesture.addTarget(self, action: #selector(handlePopGesture))
        }

        viewModel.loadRates()
    }
    
    // MARK: - Setup

    private func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBack)
        )
    }

    private func setupLayout() {
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupActions() {
        cardView.fromAmountField.delegate = self

        cardView.swapButton.addTarget(
            self,
            action: #selector(handleSwap),
            for: .touchUpInside
        )
    }
    
    private func setupTextFields() {
        if let amount = viewModel.amount {
            cardView.fromAmountField.text = String(format: "%.2f", amount)
        } else {
            cardView.fromAmountField.text = ""
        }
        cardView.fromCurrencyButton.setTitle("\(viewModel.fromCurrency) ▾", for: .normal)
        cardView.toCurrencyButton.setTitle("\(viewModel.toCurrency) ▾", for: .normal)

    }

    // MARK: - Bindings

    private func bindViewModel() {

        viewModel.$convertedAmount
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                if let value {
                    self?.cardView.toAmountLabel.text = String(format: "%.2f", value)
                    self?.cardView.toAmountLabel.textColor = .label
                } else {
                    self?.cardView.toAmountLabel.text = "0.00"
                    self?.cardView.toAmountLabel.textColor = .placeholderText
                }
            }
            .store(in: &cancellables)
        
        viewModel.$availableCurrencies
            .receive(on: RunLoop.main)
            .sink { [weak self] currencies in
                guard !currencies.isEmpty else { return }
                self?.updateCurrencyMenus(currencies: currencies)
            }
            .store(in: &cancellables)

        viewModel.$fromCurrency
            .sink { [weak self] code in
                self?.cardView.fromCurrencyButton.setTitle("\(code) ▾", for: .normal)
            }
            .store(in: &cancellables)

        viewModel.$toCurrency
            .sink { [weak self] code in
                self?.cardView.toCurrencyButton.setTitle("\(code) ▾", for: .normal)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] loading in
                self?.cardView.fromAmountField.isEnabled = !loading
                self?.cardView.swapButton.isEnabled = !loading
            }
            .store(in: &cancellables)
    }

    // MARK: - UITextFieldDelegate

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        let current = textField.text ?? ""
        guard let r = Range(range, in: current) else { return true }

        let futureText = current.replacingCharacters(in: r, with: string)
        let normalized = futureText.replacingOccurrences(of: ",", with: ".")

        if normalized.isEmpty {
            viewModel.amount = nil
            return true
        }

        if normalized == "." {
            return true
        }
        
        guard let value = Double(normalized) else {
            return false
        }

        viewModel.amount = value
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let amount = viewModel.amount else {
            textField.text = ""
            return
        }
        textField.text = String(format: "%.2f", amount)
    }
    
    // MARK: - Actions

    @objc private func handleSwap() {
        let from = viewModel.fromCurrency
        viewModel.fromCurrency = viewModel.toCurrency
        viewModel.toCurrency = from

        UIView.animate(withDuration: 0.2) {
            self.cardView.swapButton.transform =
                self.cardView.swapButton.transform.rotated(by: .pi)
        }
    }

    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handlePopGesture() {
        view.endEditing(true)
    }

    private func updateCurrencyMenus(currencies: [String]) {

        let fromActions = currencies.map { code in
            UIAction(title: code) { [weak self] _ in
                self?.viewModel.fromCurrency = code
            }
        }

        let toActions = currencies.map { code in
            UIAction(title: code) { [weak self] _ in
                self?.viewModel.toCurrency = code
            }
        }

        cardView.fromCurrencyButton.menu = UIMenu(children: fromActions)
        cardView.toCurrencyButton.menu = UIMenu(children: toActions)

        cardView.fromCurrencyButton.showsMenuAsPrimaryAction = true
        cardView.toCurrencyButton.showsMenuAsPrimaryAction = true
    }
}

