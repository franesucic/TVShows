//
//  ProfileViewController.swift
//  TV Shows
//
//  Created by Frane Sučić on 01.08.2023..
//

import UIKit
import Alamofire
import Kingfisher
import MBProgressHUD

protocol ProfileViewControllerDelegate: AnyObject {
    func didSelectLogout()
}

final class ProfileViewController: UIViewController {

    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var profileImage: UIImageView!
    
    var authInfo: AuthInfo?
    var userData: UserResponse?
    private let imagePicker = UIImagePickerController()
    
    weak var delegate: ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        fetchData()
        setupUI()
    }
    
}

// MARK: SetupUI

private extension ProfileViewController {
    
    func setupUI() {
        navigationItem.title = "My Account"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonHandler))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor.systemGray6
        profileImage.layer.cornerRadius = 50
    }
    
    @objc
    func closeButtonHandler() {
        dismiss(animated: true)
    }
    
}

// MARK: IBAction

private extension ProfileViewController {
    
    @IBAction func changeProfilePhotoHandler() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @IBAction func logoutHandler() {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            UserDefaults.standard.removeObject(forKey: "loggedUser")
            self.authInfo = nil
            self.delegate?.didSelectLogout()
        }
    }
    
}

// MARK: UIImagePickerController methods

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            storeImage(image: pickedImage)
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

// MARK: API calls

private extension ProfileViewController {
    
    func fetchData() {
        guard let info = authInfo else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
        AF.request(
            "https://tv-shows.infinum.academy/users/me",
            method: .get,
            headers: HTTPHeaders(info.headers))
        .validate()
        .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
            guard let self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            switch dataResponse.result {
            case .success(let response):
                self.userData = response
                self.emailLabel.text = response.user.email
                self.setupProfileImage(using: response)
            case .failure:
                print("Error while fetching profile data")
            }
        }
    }
    
    func storeImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.4), let headers = authInfo?.headers else { return }
        let requestData = MultipartFormData()
        requestData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
        MBProgressHUD.showAdded(to: view, animated: true)
        
        AF.upload(multipartFormData: requestData,
                  to: "https://tv-shows.infinum.academy/users",
                  method: .put,
                  headers: HTTPHeaders(headers))
        .validate()
        .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
            guard let self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            switch dataResponse.result {
            case .success(let response):
                self.setupProfileImage(using: response)
            case .failure:
                print("Error with uploading profile image.")
            }
        }
    }
    
    func setupProfileImage(using response: UserResponse) {
        if let currentImage = response.user.imageUrl {
            self.profileImage.kf.setImage(with: URL(string: currentImage))
        } else {
            self.profileImage.image = UIImage(named: "ic-profile-placeholder")
        }
    }
    
}
