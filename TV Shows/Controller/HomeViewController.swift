//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Frane Sučić on 22.07.2023..
//

import UIKit
import Alamofire
import MBProgressHUD

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    private var shows: [Show]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: view, animated: true)
        configuration()
        fetchTvShows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "TV Shows"
    }

}

// MARK: API request for shows

private extension HomeViewController {
    
    func fetchTvShows() {
        guard let authInfo else {
            MBProgressHUD.hide(for: view, animated: true)
            return
        }
        AF
            .request("https://tv-shows.infinum.academy/shows",
                     method: .get,
                     parameters: ["page":"1", "items":"100"],
                     headers: HTTPHeaders(authInfo.headers))
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] showsResponse in
                guard let self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch showsResponse.result {
                case .success(let response) :
                    self.shows = response.shows
                    self.tableView.reloadData()
                case .failure(let error) :
                    print(error)
                }
            }
    }
    
}

// MARK: TableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowListTableViewCell.self)) as! ShowListTableViewCell
        if let shows {
            cell.configure(using: shows[indexPath.row])
        }
        return cell
    }

}

// MARK: TableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let shows else { return }
        navigate(currentShow: shows[indexPath.row])
    }
    
}

// MARK: Navigation

extension HomeViewController {
    
    func navigate(currentShow: Show) {
        let storyboard = UIStoryboard(name: "Details", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: String(describing: ShowDetailsViewController.self)) as! ShowDetailsViewController
        detailsVC.show = currentShow
        detailsVC.authInfo = authInfo
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

// MARK: Private

private extension HomeViewController {
    
    func configuration() {
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }
    
    func setupUI() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        let profileDetailsItem = UIBarButtonItem(image: UIImage(named: "ic-profile"), style: .plain, target: self, action: #selector(profileDetailsHandler))
        navigationItem.rightBarButtonItem = profileDetailsItem
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1)
    }
    
    @objc
    func profileDetailsHandler() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let navigationVC = UINavigationController(rootViewController: profileVC)
        profileVC.authInfo = authInfo
        profileVC.delegate = self
        present(navigationVC, animated: true)
    }
    
}

// MARK: ProfileViewControllerDelegate

extension HomeViewController: ProfileViewControllerDelegate {
    
    func didSelectLogout() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.setViewControllers([loginVC], animated: true)
    }
    
}
