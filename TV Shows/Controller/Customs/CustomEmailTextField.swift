//
//  CustomTextField.swift
//  TV Shows
//
//  Created by Frane Sučić on 11.07.2023..
//

import UIKit

final class CustomEmailTextField: CustomTextField {
    
    private let placeholderText = "Enter email adress..."
    
    required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    
}
