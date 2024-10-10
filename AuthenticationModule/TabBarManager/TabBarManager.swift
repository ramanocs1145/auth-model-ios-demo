//
//  TabBarManager.swift
//  AuthenticationModule
//
//  Created by Ramanathan on 06/08/24.
//

import UIKit

class TabBarManager {
    
    // Singleton instance
    static let shared = TabBarManager()
    
    private init() {}
    
    // Method to create and configure the TabBarController
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        // Create view controllers
        let homeVC = HomeViewController()
        let favoritesVC = FavoritesViewController()
        let accountVC = AccountViewController()
        
        // Set tab bar items
        homeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        accountVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        
        // Set view controllers
        tabBarController.viewControllers = [homeVC, favoritesVC, accountVC]
        
        return tabBarController
    }
    
    // Method to present the TabBarController after a successful login
    func presentTabBarController(from window: UIWindow?) {
        let tabBarController = createTabBarController()
        
        // Transition to the TabBarController
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

