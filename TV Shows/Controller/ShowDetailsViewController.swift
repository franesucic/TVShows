//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Frane Sučić on 23.07.2023..
//

import UIKit
import Alamofire
import MBProgressHUD

final class ShowDetailsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var show: Show?
    var authInfo: AuthInfo?
    private var reviews: ReviewsResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchReviews()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = show?.title
    }
    
}

// MARK: Setup UI

extension ShowDetailsViewController {
    
    func setupUI() {
        MBProgressHUD.showAdded(to: view, animated: true)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.allowsSelection = false
    }
    
}

// MARK: Fetching reviews

extension ShowDetailsViewController {
    
    func fetchReviews() {
        guard let currentId = show?.id else { return }
        guard let headers = authInfo?.headers else { return }
        AF
            .request("https://tv-shows.infinum.academy/shows/\(currentId)/reviews",
                     method: .get,
                     parameters: ["page":"1", "items":"10"],
                     headers: HTTPHeaders(headers))
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { [weak self] reviewsResponse in
                guard let self = self else {return}
                MBProgressHUD.hide(for: self.view, animated: true)
                switch reviewsResponse.result {
                case .success(let response):
                    self.reviews = response
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}

// MARK: TableViewDataSource

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (reviews?.reviews.count ?? 1) + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DescriptionTableViewCell.self)) as! DescriptionTableViewCell
            if let currentShow = show, let currentReviews = reviews {
                cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
                cell.configure(for: currentShow, and: currentReviews.reviews)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewTableViewCell.self)) as! ReviewTableViewCell
            if let currentReviews = reviews {
                cell.configure(for: currentReviews.reviews[indexPath.row - 1])
            }
            return cell
        }
    }
    
}

// MARK: TableViewDelegate

extension ShowDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: Private

private extension ShowDetailsViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

// MARK: IBAction

extension ShowDetailsViewController {
    
    @IBAction func writeReviewButtonPressed() {
        let storyboard = UIStoryboard(name: "Review", bundle: nil)
        let writeVC = storyboard.instantiateViewController(withIdentifier: String(describing: WriteReviewViewController.self)) as! WriteReviewViewController
        writeVC.show = show
        writeVC.authInfo = authInfo
        writeVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: writeVC)
        present(navigationVC, animated: true)
    }
    
}

// MARK: WriteReview delegate

extension ShowDetailsViewController: WriteReviewViewControllerDelegate {
    
    func reloadReviews(with review: Review) {
        reviews?.reviews.append(review)
        tableView.reloadData()
    }
    
}
