//
//  ShowListTableViewCell.swift
//  TV Shows
//
//  Created by Frane Sučić on 24.07.2023..
//

import UIKit
import Kingfisher

final class ShowListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var showTitle: UILabel!

    func configure(using data: Show) {
        iconImageView.layer.cornerRadius = 4
        showTitle.text = data.title
        iconImageView.kf.setImage(
            with: URL(string: data.imageUrl),
            placeholder: UIImage(named: "ic-show-placeholder-vertical"))
    }
    
}
