//
//  CustomTextField.swift
//  TV Shows
//
//  Created by Frane Sučić on 22.07.2023..
//

import UIKit

class CustomTextField: UITextField {
    
    private let textPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 45)
    private var bottomLayer: CALayer?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
}

// MARK: - Setup UI -

private extension CustomTextField {
    
    func setupUI() {
        setupBottomBorder()
    }
    
    func setupBottomBorder() {
        bottomLayer?.removeFromSuperlayer()
        bottomLayer = CALayer()
        guard let bottomLayer else { return }
        bottomLayer.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 1)
        bottomLayer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        layer.addSublayer(bottomLayer)
    }
    
}
