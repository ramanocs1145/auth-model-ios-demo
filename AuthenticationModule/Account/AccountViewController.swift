//
//  AccountViewController.swift
//  AuthenticationModule
//
//  Created by Ramanathan on 06/08/24.
//

import UIKit
import AuthUI

class AccountViewController: UIViewController {
    
    private var userProfileButton: UIButton!
    private var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        setupNavigationBarAppearance()
        setupView()
    }
    
    private func setupNavigationBarAppearance() {
        // Create an appearance object
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // or .configureWithTransparentBackground() for transparency
        
        // Customize the appearance
        appearance.backgroundColor = UIColor.systemPurple // Set background color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 18)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 32)]
        
        // Apply the appearance to the navigation bar
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white // This affects the bar button items and back button
                
        navigationItem.backButtonTitle = " " // This sets the title of the back button
        
        self.title = "Account"
    }
    
    private func setupView() {
        setupUserProfileButton()
        setupLogoutButton()
        
        // Set up constraints
        setupConstraints()
    }
    
    // Setup User Profile Button
    private func setupUserProfileButton() {
        let userProfileButton = UIButton(type: .system)
        userProfileButton.setTitle("Fetch User Profile", for: .normal)
        userProfileButton.setTitleColor(.white, for: .normal)
        userProfileButton.addTarget(self, action: #selector(handleFetchUserProfile), for: .touchUpInside)
        userProfileButton.translatesAutoresizingMaskIntoConstraints = false
        userProfileButton.backgroundColor = .systemPink
        userProfileButton.layer.cornerRadius = 5
        userProfileButton.layer.masksToBounds = true
        
        self.userProfileButton = userProfileButton
        
        self.view.addSubview(userProfileButton)
    }
    
    // Setup Logout Button
    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.backgroundColor = .systemPink
        logoutButton.layer.cornerRadius = 5
        logoutButton.layer.masksToBounds = true
        
        self.logoutButton = logoutButton
        
        self.view.addSubview(logoutButton)
    }
    
    // Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // User Profile Button Constraints
            userProfileButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            userProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userProfileButton.heightAnchor.constraint(equalToConstant: 44),
            userProfileButton.widthAnchor.constraint(equalToConstant: 250),


            // Logout Button Constraints
            logoutButton.topAnchor.constraint(equalTo: userProfileButton.bottomAnchor, constant: 10),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 250),
            
        ])
    }
}

extension AccountViewController {
    // Fetch User Profile Action
    @objc private func handleFetchUserProfile() {
        // Retrieve access token
        guard let retrievedToken = KeychainHelper.shared.retrieveAccessToken(forKey: Keys.accessTokenKey) else {
            debugPrint("Failed to retrieve access token")
            UIAlertViewController_Extension.showSimpleAlert(from: self, title: "AuthenticationModule", message: "Failed to retrieve access token")
            return
        }
        debugPrint("Retrieved access token: \(retrievedToken)")
        let fetchUserProfileService = FetchUserProfileService(network: NetworkFactory())
        fetchUserProfileService.fetchUserProfileRequest(accessToken: retrievedToken, completionHandler: { (result) in
            switch result {
            case .success(let response):
                // Handle successful response
                debugPrint("Received user profile success response: \(response)")
                DispatchQueue.main.async {
                    UIAlertViewController_Extension.showSimpleAlert(from: self, title: "AuthenticationModule", message: "Successfully retrieved logged user profile")
                }
            case .failure(let error):
                // Handle error
                debugPrint("Failed with error: \(error)")
                DispatchQueue.main.async {
                    UIAlertViewController_Extension.showSimpleAlert(from: self, title: "AuthenticationModule", message: error.localizedDescription)
                }
            }
        })
    }
}

extension AccountViewController {
    // Logout Action
    @objc private func handleLogout() {
        // Retrieve access token
        guard let retrievedToken = KeychainHelper.shared.retrieveAccessToken(forKey: Keys.accessTokenKey) else {
            debugPrint("Failed to retrieve access token")
            UIAlertViewController_Extension.showSimpleAlert(from: self, title: "AuthenticationModule", message: "Failed to retrieve access token")
            return
        }
        debugPrint("Retrieved access token: \(retrievedToken)")
        AuthUI.KeychainHelper.clearAuthDataDuringLogout(accessToken: retrievedToken,
                                                        delegate: self,
                                                        completionHandler: { (result) in
            switch result {
            case .success(let response):
                // Handle successful response
                debugPrint("Received Logout response: \(response)")
                DispatchQueue.main.async {
                    self.deleteStoredAccessTokenDetails()
                    self.resetAppState()
                }
            case .failure(let error):
                // Handle error
                debugPrint("Failed with error: \(error)")
                DispatchQueue.main.async {
                    UIAlertViewController_Extension.showSimpleAlert(from: self, title: "AuthenticationModule", message: error.errorMessage)
                }
            }
        })
    }
    
    private func deleteStoredAccessTokenDetails() {
        // Delete access token
        let isDeleteSuccess = KeychainHelper.shared.deleteAccessToken(forKey: Keys.accessTokenKey)
        debugPrint("Delete access token: \(isDeleteSuccess)")
    }
    
    private func storeNewAccessToken(_ accessToken: String) {
        // Store new access token
        let isStoreSuccess = KeychainHelper.shared.storeAccessToken(accessToken, forKey: Keys.accessTokenKey)
        debugPrint("Store new access token: \(isStoreSuccess)")
    }
    
    private func resetAppState() {
        let loginViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}

extension AccountViewController: AuthUI.AuthServiceHelperDelegate {
    func didReceiveAccessToken(_ accessToken: String) {
        self.deleteStoredAccessTokenDetails()
        self.storeNewAccessToken(accessToken)
    }
}
