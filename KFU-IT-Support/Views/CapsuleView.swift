//
//  CapsuleView.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 14.04.2024.
//

import UIKit

final class CapsuleView: UIView {

    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .primaryKFU
        addSubview(textLabel)

        textLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        snp.makeConstraints {
            $0.height.equalTo(30)
        }

        layer.cornerRadius = 15
        layer.masksToBounds = true
    }

    func setText(_ text: String) {
        textLabel.text = text
    }

    func setTextWithAttribute(_ attributedString: NSAttributedString) {
        textLabel.attributedText = attributedString
    }
}
