//
//  MainTabBarController.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    var makeListView: ((UINavigationController) -> UIViewController)?
    var makeSearchView: ((UINavigationController) -> UIViewController)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let listNavigationController = UINavigationController()
        let cuteDogsListViewController = makeListView!(listNavigationController)
        listNavigationController.setViewControllers([cuteDogsListViewController], animated: false)
        
        let searchNavigationController = UINavigationController()
        let searchViewController = makeSearchView!(searchNavigationController)
        searchNavigationController.setViewControllers([searchViewController], animated: false)
        
        let appearance = UINavigationBarAppearance()
        let img = UIImage()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemMint
        appearance.shadowImage = img
        appearance.shadowColor = .clear
        
        listNavigationController.navigationBar.standardAppearance = appearance
        listNavigationController.navigationBar.scrollEdgeAppearance = appearance
        
        searchNavigationController.navigationBar.standardAppearance = appearance
        searchNavigationController.navigationBar.scrollEdgeAppearance = appearance

        viewControllers = [listNavigationController, searchNavigationController]
        
        if let tabBarItems = tabBar.items {
            let wordsTabBarItem = tabBarItems[0]
            wordsTabBarItem.title = "List"
            wordsTabBarItem.image = UIImage(systemName: "square.fill.text.grid.1x2")
            
            let pendingTabBarItem = tabBarItems[1]
            pendingTabBarItem.title = "Search"
            pendingTabBarItem.image = UIImage(systemName: "magnifyingglass")
        }
    }
}
