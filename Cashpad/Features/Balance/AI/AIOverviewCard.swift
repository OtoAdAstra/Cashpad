//
//  AIOverviewCard.swift
//  Cashpad
//

import UIKit

final class AIOverviewCard: UIView {

    // MARK: - Subviews

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline).withTraits(.traitBold)
        label.textColor = .secondaryLabel
        label.text = "✦ AI Overview"
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.text = "Generating overview…"
        label.isHidden = true
        return label
    }()

    private let loadingStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        sv.isHidden = true
        return sv
    }()

    private let contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        sv.alignment = .fill
        return sv
    }()

    // MARK: - State

    private let viewModel = AIOverviewViewModel()
    private var generateTask: Task<Void, Never>?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous

        loadingStack.addArrangedSubview(spinner)
        loadingStack.addArrangedSubview(loadingLabel)

        contentStack.addArrangedSubview(headerLabel)
        contentStack.addArrangedSubview(loadingStack)
        contentStack.addArrangedSubview(bodyLabel)

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    // MARK: - Public

    func generate(accountName: String, currency: String, balance: Double, transactions: [Transaction]) {
        generateTask?.cancel()
        generateTask = Task { @MainActor in
            spinner.startAnimating()
            loadingStack.isHidden = false
            bodyLabel.isHidden = true
            isHidden = false

            await viewModel.generate(
                accountName: accountName,
                currency: currency,
                balance: balance,
                transactions: transactions
            )

            guard !Task.isCancelled else { return }

            spinner.stopAnimating()
            loadingStack.isHidden = true

            if viewModel.isUnavailable {
                isHidden = true
            } else {
                bodyLabel.text = viewModel.overviewText
                bodyLabel.isHidden = viewModel.overviewText.isEmpty
            }
        }
    }
}

// MARK: - UIFont helper

private extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
