//
//  WriteViewController.swift
//  TV Shows
//
//  Created by Frane Sučić on 24.07.2023..
//

import UIKit
import Alamofire
import MBProgressHUD

protocol WriteReviewViewControllerDelegate: AnyObject {
    func reloadReviews(with review: Review)
}

final class WriteReviewViewController: UIViewController {

    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var submitButton: UIButton!
    
    weak var delegate: WriteReviewViewControllerDelegate?
    
    var show: Show? = nil
    var authInfo: AuthInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: Setup UI

extension WriteReviewViewController {
    
    func configure() {
        ratingView.delegate = self
        submitButton.isEnabled = false
        setupTextView()
        setupNavigationItems()
    }
    
    func setupNavigationItems() {
        navigationItem.title = "Write a Review"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor.systemGray6
    }
    
    func setupTextView() {
        commentTextView.delegate = self
        commentTextView.text = "Enter your comment here..."
        commentTextView.textColor = UIColor.systemGray2
        commentTextView.layer.cornerRadius = 10
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
    }
    
    @objc
    func closeButtonPressed() {
        dismiss(animated: true)
    }
    
}

// MARK: IBAction

extension WriteReviewViewController {
    
    @IBAction func submitButtonPressed() {
        guard let show, let comment = commentTextView.text, let headers = authInfo?.headers else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
        let parameters = ReviewParameters(rating: ratingView.rating, comment: comment, showId: show.id)
        
        AF.request("https://tv-shows.infinum.academy/reviews",
                     method: .post,
                     parameters: parameters,
                     encoder: JSONParameterEncoder.default,
                     headers: HTTPHeaders(headers))
            .validate()
            .responseDecodable(of: SingleReviewResponse.self) { [weak self] dataResponse in
                guard let self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                
                switch dataResponse.result {
                case .success(let response):
                    self.delegate?.reloadReviews(with: response.review)
                    self.dismiss(animated: true)
                case .failure:
                    self.presentAlert(message: "Writing review failed.")
                }
        }
    }
}

// MARK: RatingViewDelegate

extension WriteReviewViewController: RatingViewDelegate {
    
    func didChangeRating(_ rating: Int) {
        submitButton.isEnabled = true
    }
    
}

// MARK: UITextView delegate

extension WriteReviewViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentTextView.text = ""
        commentTextView.textColor = UIColor.black
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        guard commentTextView.text == "" else { return }
        commentTextView.textColor = UIColor.systemGray2
        commentTextView.text = "Enter your comment here..."
    }
    
}

// MARK: Alert

extension WriteReviewViewController {
    
    func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { action in
            return
        }
        alertVC.addAction(alertAction)
        present(alertVC, animated: true)
    }
    
}
