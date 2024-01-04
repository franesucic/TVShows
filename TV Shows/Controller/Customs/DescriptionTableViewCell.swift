//
//  DetailsOneTableViewCell.swift
//  TV Shows
//
//  Created by Frane Sučić on 24.07.2023..
//

import UIKit

final class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet private weak var showImage: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var noReviewsLabel: UILabel!

}

// MARK: Cell configuration

extension DescriptionTableViewCell {
    
    func configure(for show: Show, and reviews: [Review]) {
        guard !reviews.isEmpty else {
            setNoReviews(show: show)
            return
        }
        setupDescriptionCell(show: show, reviews: reviews)
    }
    
    func setNoReviews(show: Show) {
        descriptionLabel.text = show.description
        noReviewsLabel.isHidden = false
        ratingView.isHidden = true
        ratingLabel.isHidden = true
    }
    
    func setupDescriptionCell(show: Show, reviews: [Review]) {
        let sumage = reviews.map(\.rating).reduce(0, +)
        ratingLabel.text = String(format: "%d REVIEWS, %.1f AVERAGE", reviews.count, Double(sumage) / Double(reviews.count))
        descriptionLabel.text = show.description
        ratingView.isEnabled = false
        noReviewsLabel.isHidden = true
        showImage.layer.cornerRadius = 15
        showImage.kf.setImage(
            with: URL(string: show.imageUrl),
            placeholder: UIImage(named: "ic-show-placeholder-rectangle"))
        if let rating = show.averageRating {
            ratingView.setRoundedRating(Double(rating))
        }
    }
    
}
