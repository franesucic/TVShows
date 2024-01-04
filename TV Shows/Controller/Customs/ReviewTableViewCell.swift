//
//  DetailsTwoTableViewCell.swift
//  TV Shows
//
//  Created by Frane Sučić on 24.07.2023..
//

import UIKit

final class ReviewTableViewCell: UITableViewCell {

    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

}

// MARK: Cell configuration

extension ReviewTableViewCell {
    
    func configure(for review: Review) {
        profileImage.layer.cornerRadius = 25
        emailLabel.text = review.user.email
        commentLabel.text = review.comment
        ratingView.setRoundedRating(Double(review.rating))
        if let userImage = review.user.imageUrl {
            profileImage.kf.setImage(with: URL(string: userImage))
        } else {
            profileImage.image = UIImage(named: "ic-profile-placeholder")
        }
    }
    
}

// MARK: Setup UI

extension ReviewTableViewCell {
    
    func setupUI() {
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
}
