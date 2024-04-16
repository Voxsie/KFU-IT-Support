//
//  TextField.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 02.04.2024.
//

import UIKit

protocol PrimaryTextFieldViewDelegate: AnyObject {
    func valueChangedTo(_ text: String)
    func valueChangedWithTag(_ text: String, tag: Int)
    func sixDigitsEntered(_ code: String)
    func didEditingWith(_ text: String)
}

extension PrimaryTextFieldViewDelegate {
    func valueChangedTo(_ text: String) { }
    func sixDigitsEntered(_ code: String) { }
    func valueChangedWithTag(_ text: String, tag: Int) { }
    func didEditingWith(_ text: String) { }
}

class TextField: UIView {

    // MARK: Public data structures

    enum `Type` {
        case standard
        case password
    }

    // MARK: - Open Properties

    // MARK: - UI Elements

    private lazy var textField = UITextField()

    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 12))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    fileprivate lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 16))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()

    fileprivate lazy var bottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()

    fileprivate let passwordEyeButton = UIButton()

    // MARK: Public properties

    weak var delegate: PrimaryTextFieldViewDelegate?

    var textFieldDelegate: UITextFieldDelegate? {
        get { textField.delegate }
    }

    var text: String = "" {
        willSet {
            if newValue.count != 0, text == "" {
                textEntered()
            } else if text != "", newValue.count == 0 {
                if needPlaceholder {
                    textRemoved()
                }
            }
        }
    }

    var setText: String = "" {
        didSet {
            textEntered()
            textField.text = setText
            delegate?.valueChangedWithTag(setText, tag: textField.tag)
        }
    }

    var textContentType: UITextContentType {
        didSet {
            textField.textContentType = textContentType
        }
    }

    var keyboardType: UIKeyboardType {
        didSet {
            textField.keyboardType = keyboardType
        }
    }

    var shouldReturn: Bool = false

    // MARK: - Private Properties

    private var type: Type {
        didSet {
            switch type {
            case .password:
                makeItPassword()

            default:
                break

            }
        }
    }

    private var placeholder: String

    private var needPlaceholder: Bool

    // MARK: - Initializer

    init(
        type: Type = .standard,
        textContentType: UITextContentType,
        keyboardType: UIKeyboardType,
        placeholder: String,
        needPlaceholder: Bool = true
    ) {
        self.type = type
        self.placeholder = placeholder
        self.textContentType = textContentType
        self.keyboardType = keyboardType
        self.needPlaceholder = needPlaceholder

        super.init(frame: .zero)

        setupTypeDifference()
        setupConstrains()
        setupElements()
        if !needPlaceholder {
            titleLabel.isHidden = false
            titleLabel.alpha = 1
            placeholderLabel.text = ""
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func getValue() -> String { textField.text ?? "" }
    func makeFirstResponder() { _ = textField.becomeFirstResponder() }
    func deleteFirstResponder() { textField.resignFirstResponder() }
    func setPlaceholder(text: String) { placeholderLabel.text = text; titleLabel.text = text }

    // MARK: - Setup Functions

    private func setupTypeDifference() {
        switch type {
        case .password: makeItPassword()
        default: break
        }
    }

    private func setupConstrains() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.greaterThanOrEqualTo(18)
        }

        addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(32)
        }

        textField.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(24)
            $0.bottom.equalToSuperview().inset(3)
        }
    }

    private func setupElements() {
        self.translatesAutoresizingMaskIntoConstraints = false

        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.delegate = self
        textField.borderStyle = .none
        textField.placeholder = ""

        textField.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        titleLabel.text = placeholder
        placeholderLabel.text = placeholder

        passwordEyeButton.isHidden = true
    }

    @objc
    private func textFieldValueChanged() {
        text = textField.text ?? ""
        delegate?.valueChangedTo(text)
        delegate?.valueChangedWithTag(text, tag: textField.tag)
    }

    // MARK: - Private Function

    private func makeItPassword() {
        textField.isSecureTextEntry = true
        addPasswordEye()
    }

    private func addPasswordEye() {
        passwordEyeButton.setImage(
            svgImage(
                image: Asset.Icons.textFieldPasswordEye.image,
                width: 25,
                height: 25
            ),
            for: .normal
        )
        passwordEyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passwordEyeButton.frame = CGRect(
            x: CGFloat(textField.frame.size.width - 25),
            y: CGFloat(5),
            width: CGFloat(25),
            height: CGFloat(25)
        )
        passwordEyeButton.addTarget(self, action: #selector(passwordEyeButtonPressed), for: .touchUpInside)
        textField.rightView = passwordEyeButton
        textField.rightViewMode = .always
    }

    @objc
    private func passwordEyeButtonPressed() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        textField.isSecureTextEntry.toggle()
        passwordEyeButton.setImage(
            svgImage(
                image: textField.isSecureTextEntry ?
                Asset.Icons.textFieldPasswordEye.image :
                Asset.Icons.textFieldPasswordEyeHide.image,
                width: 25,
                height: 25
            ),
            for: .normal
        )
    }

    private func textEntered() {
        passwordEyeButton.isHidden = false
        placeholderLabel.alpha = 0
        titleLabel.alpha = 1
    }

    private func textRemoved() {
        passwordEyeButton.isHidden = true
        placeholderLabel.alpha = 1
        titleLabel.alpha = 0
    }

    func setTextFieldTag(tag: Int) {
        textField.tag = tag
    }
}

// MARK: - UITextFieldDelegate

extension TextField: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5) {
            self.bottomLineView.backgroundColor = .label
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.didEditingWith(text)
        UIView.animate(withDuration: 0.5) {
            self.bottomLineView.backgroundColor = .separator
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if shouldReturn {
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if type == .password && string == " " { return false } else { return true }
    }
}
