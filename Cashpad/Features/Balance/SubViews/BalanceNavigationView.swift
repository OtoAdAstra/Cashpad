//
//  BalanceNavigationView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 16.01.26.
//

import UIKit

final class BalanceNavigationView: UIView {
    
    // MARK: - UI
    
    private let stack = UIStackView()
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private let exchangeButton = UIButton()
    
    private let arrowLeft: UIImage? = {
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let image = UIImage(systemName: "arrow.left", withConfiguration: config)
        return image?.withTintColor(UIColor.systemBlue, renderingMode: .alwaysOriginal)
    }()
    
    private let exchangeSymbol: UIImage? = {
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let image = UIImage(systemName: "creditcard.arrow.trianglehead.2.clockwise.rotate.90", withConfiguration: config)
        return image?.withTintColor(UIColor.systemBlue, renderingMode: .alwaysOriginal)
    }()

    // MARK: - Actions

    var onBack: (() -> Void)?
    var onExchange: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor(named: "Background")

        stack.axis = .horizontal
        stack.spacing = 14
        stack.alignment = .center

        addSubview(stack)
        stack.addArrangedSubview(backButton)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(exchangeButton)

        backButton.configuration = .glass()
        backButton.layer.cornerRadius = 24
        backButton.setImage(arrowLeft, for: .normal)
        backButton.tintColor = .label
        
        exchangeButton.configuration = .glass()
        exchangeButton.layer.cornerRadius = 24
        exchangeButton.setImage(exchangeSymbol, for: .normal)
        exchangeButton.tintColor = .label

        backButton.addAction(
            UIAction { [weak self] _ in
                self?.onBack?()
            },
            for: .touchUpInside
        )
        
        exchangeButton.addAction(
            UIAction { [weak self] _ in
                self?.onExchange?()
            },
            for: .touchUpInside
        )

        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        stack.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        exchangeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -18),

            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            
            exchangeButton.widthAnchor.constraint(equalToConstant: 48),
            exchangeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    // MARK: - Coinfig

    func configure(title: String) {
        titleLabel.text = title
    }
}

