//
//  FavoritesViewController.swift
//  AuthenticationModule
//
//  Created by Ramanathan on 06/08/24.
//

import UIKit

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple

        setupNavigationBarAppearance()
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
        
        self.title = "Favorites"
    }
}
