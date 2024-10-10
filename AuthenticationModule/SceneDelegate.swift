//
//  SceneDelegate.swift
//  AuthenticationModule
//
//  Created by Ramanathan on 01/08/24.
//

import UIKit
import AuthUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Configure AuthUI Module.
        configureAndInitializeAuthUIModule()

        // Ensure the scene is a UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create a new UIWindow with the windowScene
        let window = UIWindow(windowScene: windowScene)

        // Create an instance of your initial view controller
        let initialViewController = ViewController()
        
        let navController = UINavigationController(rootViewController: initialViewController)
        
        // Set the root view controller to your initial view controller
        window.rootViewController = navController

        // Make this window visible
        window.makeKeyAndVisible()

        // Assign the window to the SceneDelegate's window property
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    
    private func configureAndInitializeAuthUIModule() {
        // Update base URL dynamically
//        let _ = AuthUI.Configuration.shared.updateConfigurationData("https://37c226d0-fe14-4144-9c64-8a436cf214fc.mock.pstmn.io/", apiVersion: "v1")
//        let _ = AuthUI.Configuration.shared.updateConfigurationData("http://192.168.29.3:8080/", apiVersion: "v1") - Wifi Current -> wifi ->192.168.29.3
//        let _ = AuthUI.Configuration.shared.updateConfigurationData("http://192.168.1.189:8080/", apiVersion: "v1") - LAN Old
//        let _ = AuthUI.Configuration.shared.updateConfigurationData("http://192.168.1.186:8080/", apiVersion: "v2") //Latest LAN -> lan -> 192.168.1.186

        let _ = AuthUI.Configuration.shared.updateConfigurationData("http://192.168.29.3:8080/", apiVersion: "v2") //Latest LAN

        // Access the updated base URL
        debugPrint("BaseURL ==> \(AuthUI.Configuration.shared.baseURL ?? "") && Api Version ==>\(AuthUI.Configuration.shared.apiVersion ?? "")")
    }
}
