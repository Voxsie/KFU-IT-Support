//
//  Button.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 02.04.2024.
//

import UIKit

final class Button: UIButton {

    // MARK: Private Data structures

    private struct ButtonState {
        var state: UIControl.State
        var title: String?
        var image: UIImage?
    }

    // MARK: Private properties

    private var buttonStates: [ButtonState] = []

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = self.titleColor(for: .normal)
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let xCenterConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )
        let yCenterConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        self.addConstraints([xCenterConstraint, yCenterConstraint])
        return activityIndicator
    }()

    // MARK: Lifecycle

    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 10
        self.backgroundColor = Asset.Colors.primaryKFU.color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            activityIndicator.startAnimating()
            var buttonStates: [ButtonState] = []
            for state in [UIControl.State.disabled] {
                let buttonState = ButtonState(
                    state: state,
                    title: title(for: state),
                    image: image(for: state)
                )
                buttonStates.append(buttonState)
                setTitle("", for: state)
                setImage(UIImage(), for: state)
            }
            self.buttonStates = buttonStates
            isEnabled = false
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            activityIndicator.stopAnimating()
            for buttonState in buttonStates {
                setTitle(buttonState.title, for: buttonState.state)
                setImage(buttonState.image, for: buttonState.state)
            }
            isEnabled = true
        }
    }
}
