//
//  CustomPasswordTextField.swift
//  TV Shows
//
//  Created by Frane Sučić on 15.07.2023..
//

import UIKit

final class CustomPasswordTextField: CustomTextField {
    
    private let placeholderText = "Enter password..."
    
    required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    
}
