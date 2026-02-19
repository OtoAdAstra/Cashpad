//
//  ExchangeCardView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 22.01.26.
//


import UIKit

final class ExchangeCardView: UIView {

    // MARK: - UI

    let fromAmountField = UITextField()
    let toAmountLabel = UILabel()

    let fromCurrencyButton = UIButton(type: .system)
    let toCurrencyButton = UIButton(type: .system)

    let swapButton = UIButton(type: .system)

    private let divider = UIView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = UIColor(named: "SecondaryBackground")
        layer.cornerRadius = 18
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor

        fromAmountField.font = .systemFont(ofSize: 36, weight: .semibold)
        fromAmountField.keyboardType = .decimalPad
        fromAmountField.textContentType = .oneTimeCode
        fromAmountField.textColor = .label
        fromAmountField.placeholder = "0.00"
        fromAmountField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fromAmountField.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .prominent, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexible, done]
        
        fromAmountField.inputAccessoryView = toolbar

        toAmountLabel.font = .systemFont(ofSize: 36, weight: .semibold)
        toAmountLabel.textColor = .placeholderText
        toAmountLabel.text = "0.00"
        toAmountLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        toAmountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        fromCurrencyButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        toCurrencyButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)

        swapButton.setImage(
            UIImage(systemName: "arrow.up.arrow.down"),
            for: .normal
        )
        swapButton.tintColor = .systemGray

        divider.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }

    private func setupLayout() {
        let topStack = makeRow(
            left: fromAmountField,
            right: fromCurrencyButton
        )

        let bottomStack = makeRow(
            left: toAmountLabel,
            right: toCurrencyButton
        )

        let container = UIStackView(arrangedSubviews: [
            topStack,
            divider,
            bottomStack
        ])
        container.axis = .vertical
        container.spacing = 16

        addSubview(container)
        addSubview(swapButton)

        container.translatesAutoresizingMaskIntoConstraints = false
        swapButton.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            divider.heightAnchor.constraint(equalToConstant: 1),

            swapButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            swapButton.centerYAnchor.constraint(equalTo: divider.centerYAnchor),
            swapButton.heightAnchor.constraint(equalToConstant: 36),
            swapButton.widthAnchor.constraint(equalToConstant: 36)
        ])
    }

    @objc private func doneButtonTapped() {
        endEditing(true)
    }

    private func makeRow(left: UIView, right: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.axis = .horizontal
        stack.alignment = .center

        left.setContentHuggingPriority(.defaultLow, for: .horizontal)
        right.setContentHuggingPriority(.required, for: .horizontal)

        return stack
    }
}
