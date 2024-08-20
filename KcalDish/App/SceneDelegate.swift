//
//  SceneDelegate.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 05.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        self.window = window
        
        let startVC = StartViewController()
        startVC.title = "Calculate"
        
        let cookBookTVC = CookBookTableViewController()
        cookBookTVC.title = "Cook Book"
        
        let productCartTVC = ProductCartTableViewController()
        productCartTVC.title = "Product Cart"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.myColorMain
        appearance.titleTextAttributes = [.foregroundColor: UIColor.myColorText]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.myColorText]
        
        let firstNC = UINavigationController(rootViewController: startVC)
        firstNC.tabBarItem.title = "Calculate"
        firstNC.tabBarItem.image = UIImage(systemName: "fork.knife")
        firstNC.navigationBar.prefersLargeTitles = true
        firstNC.navigationBar.standardAppearance = appearance
        firstNC.navigationBar.scrollEdgeAppearance = appearance
        let secondNC = UINavigationController(rootViewController: cookBookTVC)
        secondNC.tabBarItem.title = "Cook Book"
        secondNC.tabBarItem.image = UIImage(systemName: "text.book.closed.fill")
        secondNC.navigationBar.prefersLargeTitles = true
        secondNC.navigationBar.standardAppearance = appearance
        secondNC.navigationBar.scrollEdgeAppearance = appearance
        let thirdNC = UINavigationController(rootViewController: productCartTVC)
        thirdNC.tabBarItem.title = "Product Cart"
        thirdNC.tabBarItem.image = UIImage(systemName: "cart.fill")
        thirdNC.navigationBar.prefersLargeTitles = true
        thirdNC.navigationBar.standardAppearance = appearance
        thirdNC.navigationBar.scrollEdgeAppearance = appearance
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = UIColor.myColorMain
        tabBarController.tabBar.tintColor = UIColor.myColorText
        tabBarController.tabBar.barTintColor = UIColor.myColorMain
        tabBarController.viewControllers = [firstNC, secondNC, thirdNC]
        
        
        let rootVC = tabBarController
        
        window.rootViewController = rootVC
        
        window.makeKeyAndVisible()
        
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
        
    }


}

