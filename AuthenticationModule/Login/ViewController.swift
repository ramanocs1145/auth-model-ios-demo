//
//  ViewController.swift
//  AuthenticationModule
//
//  Created by Ramanathan on 01/08/24.
//

import UIKit
import AuthUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        
        setupNavigationBackBarButtonAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ensure the login VC is presented after the view controller is in the view hierarchy
        //presentLoginViewController()
        
        presentOTPViewController()
    }
    
    private func presentLoginViewController() {
        // Instantiate the LoginViewController with a delegate
        let loginVC = AuthUI.LoginViewController(delegate: self)
        
        // Wrap LoginViewController in a UINavigationController
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        // Set the modal presentation style to fullScreen
        navigationController.modalPresentationStyle = .fullScreen
        
        // Present the UINavigationController
        present(navigationController, animated: true, completion: nil)
    }

    private func setupNavigationBackBarButtonAppearance() {
        // Create a custom back button
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
}

extension ViewController: AuthUI.LoginViewControllerDelegate {
    func loginSuccessHandler(_ accessToken: String) {
        storeAccessToken(accessToken)
        
        // Use the TabBarManager to present the TabBarController
        if let window = UIApplication.shared.windows.first {
            TabBarManager.shared.presentTabBarController(from: window)
        }
    }
    
    func registerSuccessHandler(_ accessToken: String) {
        storeAccessToken(accessToken)

        // Use the TabBarManager to present the TabBarController
        if let window = UIApplication.shared.windows.first {
            TabBarManager.shared.presentTabBarController(from: window)
        }
    }
}

extension ViewController {
    private func storeAccessToken(_ accessToken: String) {
        // Store access token
        let isSuccess = KeychainHelper.shared.storeAccessToken(accessToken, forKey: Keys.accessTokenKey)
        debugPrint("Store access token: \(isSuccess)")
    }
}

extension ViewController {
        
    private func presentOTPViewController() {
        // Instantiate the LoginViewController with a delegate
        let otpVC = AuthUI.CustomOTPViewController(fieldsCount: 6, displayType: .square, secureEntry: true, delegate: self)
        
        // Wrap LoginViewController in a UINavigationController
        let navigationController = UINavigationController(rootViewController: otpVC)
        
        // Set the modal presentation style to fullScreen
        navigationController.modalPresentationStyle = .fullScreen
        
        // Present the UINavigationController
        present(navigationController, animated: true, completion: nil)
    }
}

extension ViewController: AuthUI.CustomOTPViewControllerDelegate {
    func otpLoginSuccessHandler(_ accessToken: String) {
        storeAccessToken(accessToken)

        // Use the TabBarManager to present the TabBarController
        if let window = UIApplication.shared.windows.first {
            TabBarManager.shared.presentTabBarController(from: window)
        }
    }
    
    func otpRegisterSuccessHandler(_ accessToken: String) {
        storeAccessToken(accessToken)

        // Use the TabBarManager to present the TabBarController
        if let window = UIApplication.shared.windows.first {
            TabBarManager.shared.presentTabBarController(from: window)
        }
    }
}

