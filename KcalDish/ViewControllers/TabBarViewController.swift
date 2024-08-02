//
//  StartViewController.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 21.07.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Tab Setup
    private func setupTabs() {
        let start = self.createNavBar(with: "Calculate", and: UIImage(systemName: "fork.knife"), vc: StartViewController())
        let track = self.createNavBar(with: "Cook Book", and: UIImage(systemName: "text.book.closed.fill"), vc: CookBookTableViewController())
        
        self.setViewControllers([start, track], animated: true)
    }
    
    private func createNavBar(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }

}
