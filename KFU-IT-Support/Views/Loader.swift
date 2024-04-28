//
//  Loader.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 28.04.2024.
//

import UIKit

class Loader: UIView {

    // MARK: Private Properties

    private lazy var loaderImageView: UIImageView = {
        let image = UIImageView()
        image.image = Asset.Shapes.loader.image
        image.contentMode = .scaleAspectFit
        return image
    }()

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubview(loaderImageView)
        loaderImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public Methods

    func show() {
        isHidden = false
        self.rotate(imageView: loaderImageView, aCircleTime: 1)
    }

    func hide() {
        isHidden = true
        loaderImageView.layer.removeAnimation(forKey: "rotate")
    }

    // MARK: Private Methods

    private func rotate(imageView: UIImageView, aCircleTime: Double) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = aCircleTime
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: "rotate")
    }
}
