//
//  CurrentBalanceView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 16.01.26.
//

import UIKit

final class CurrentBalanceView: UIView {
    
    // MARK: - UI
    
    private let stack = UIStackView()
    private let titleLabel = UILabel()
    private let balanceLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup(){
        backgroundColor = UIColor(named: "Background")
        
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        addSubview(stack)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(balanceLabel)
        
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = .gray
        titleLabel.numberOfLines = 1
        titleLabel.text = "Current Balance"

        balanceLabel.font = .systemFont(ofSize: 42, weight: .bold)
        balanceLabel.textColor = .label
        balanceLabel.numberOfLines = 1
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),
        ])
    }
    
    // MARK: - Config
    
    func configure(balance: Double, currency: String){
        balanceLabel.text = "\(currency)\(BalanceFormatter.format(balance))"
    }
}
