//
//  BalanceView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 15.01.26.
//

import UIKit

final class BalanceView: UIView {

    private let balanceView = CurrentBalanceView()

    private var onBack: (() -> Void)?
    private var onExchange: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(balanceView)

        balanceView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            balanceView.topAnchor.constraint(equalTo: topAnchor),
            balanceView.leadingAnchor.constraint(equalTo: leadingAnchor),
            balanceView.trailingAnchor.constraint(equalTo: trailingAnchor),
            balanceView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    func updateBalance(
        balance: Double,
        currency: String
    ) {
        balanceView.configure(
            balance: balance,
            currency: currency
        )
    }
    
}
