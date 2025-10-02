//
//  EmptyTableViewCell.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: EmptyTableViewCell.self)
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No results found"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubview()
        updateConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubview() {
        contentView.addSubview(messageLabel)
    }

    func updateConstraint() {
        if let superview = messageLabel.superview {
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                messageLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                messageLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                messageLabel.topAnchor.constraint(equalTo: superview.topAnchor),
                messageLabel.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
        }
    }
}
