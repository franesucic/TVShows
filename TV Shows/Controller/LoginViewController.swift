//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Frane Sučić on 08.07.2023..
//

import UIKit
import MBProgressHUD
import Alamofire

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var passwordField: CustomPasswordTextField!
    @IBOutlet private weak var emailField: CustomEmailTextField!
    @IBOutlet private weak var checkBox: UIButton!
    @IBOutlet private weak var eyeButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    
    private var rememberMe = false
    private var isHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup UI -

private extension LoginViewController {
    
    func setupUI() {
        setupButtons()
    }
    
    func setupButtons() {
        checkBox.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
        checkBox.setImage(UIImage(named: "ic-checkbox-selected"), for: .selected)
        eyeButton.setImage(UIImage(named: "ic-invisible"), for: .normal)
        eyeButton.setImage(UIImage(named: "ic-visible"), for: .selected)
    }
}

// MARK: - IBAction -

private extension LoginViewController {
    
    @IBAction func rememberMePressed() {
        rememberMe.toggle()
        checkBox.isSelected.toggle()
    }
    
    @IBAction func loginPressed() {
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            return
        }
        loginUser(email: email, password: password)
    }
    
    @IBAction func registerPressed() {
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            return
        }
        registerUser(email: email, password: password)
    }
    
    @IBAction func eyeButtonPressed() {
        passwordField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }
}

// MARK: - Registration and Login

private extension LoginViewController {
    
    func registerUser(email: String, password: String) {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
        
        AF
            .request("https://tv-shows.infinum.academy/users",
                     method: .post,
                     parameters: parameters,
                     encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .failure:
                    self.presentAlert(message: "Registration failed")
                case .success(let response):
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    self.handleLogin(headers: headers, userResponse: response)
                }
            }
    }
    
    func loginUser(email: String, password: String) {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        AF
            .request("https://tv-shows.infinum.academy/users/sign_in", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                
                switch dataResponse.result {
                case .failure:
                    self.performAnimation()
                case .success(let response) :
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    self.handleLogin(headers: headers, userResponse: response)
                }
            }
    }
    
    func handleLogin(headers: [String: String], userResponse: UserResponse) {
        guard let headerInfo = try? AuthInfo(headers: headers) else {
            print("Header error")
            return
        }
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.setViewControllers([homeVC],animated:true)
        homeVC.userResponse = userResponse
        homeVC.authInfo = headerInfo
        if rememberMe { saveUserToUserDefaults(userInfo: headerInfo) }
    }
    
    func saveUserToUserDefaults(userInfo: AuthInfo) {
        guard let data = try? JSONEncoder().encode(userInfo) else { return }
        UserDefaults.standard.set(data, forKey: "loggedUser")
    }
}

// MARK: Feedbacks

extension LoginViewController {
    
    func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { action in
            return
        }
        alertVC.addAction(alertAction)
        present(alertVC, animated: true)
    }
    
    func performAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: loginButton.center.x - 10, y: loginButton.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: loginButton.center.x + 10, y: loginButton.center.y))
        loginButton.layer.add(animation, forKey: "position")
    }
    
}
