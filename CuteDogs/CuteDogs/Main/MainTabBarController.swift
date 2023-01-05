//
//  MainTabBarController.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let makeListView: ((UINavigationController) -> UIViewController)
    private let makeSearchView: ((UINavigationController) -> UIViewController)
    
    init(makeListView: @escaping ((UINavigationController) -> UIViewController), makeSearchView: @escaping ((UINavigationController) -> UIViewController)) {
        self.makeListView = makeListView
        self.makeSearchView = makeSearchView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let listNavigationController = UINavigationController()
        let cuteDogsListViewController = makeListView(listNavigationController)
        listNavigationController.setViewControllers([cuteDogsListViewController], animated: false)
        
        let searchNavigationController = UINavigationController()
        let searchViewController = makeSearchView(searchNavigationController)
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
