//
//  SubmitButton.swift
//  TV Shows
//
//  Created by Frane Sučić on 04.08.2023..
//

import UIKit

final class SubmitButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    func setupButton() {
        isEnabled = false
        backgroundColor = self.isEnabled ? #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1) : #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1).withAlphaComponent(0.2)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.white, for: .disabled)
        titleLabel?.textColor = UIColor.white
        tintColor = UIColor.white
        layer.cornerRadius = frame.size.height / 2.0
    }

}
