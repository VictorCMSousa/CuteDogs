//
//  AppFactory.swift
//  CuteDogs
//
//  Created by Victor Sousa on 19/12/2022.
//

import UIKit

final class AppFactory {
    
    private static let appSession = URLSession(configuration: .default)
    private static let networkClient = NetworkClient(session: appSession)
    private static let dogBreedsInteractor = TheDogAPIInteractor(client: networkClient)
    private static let imageLoaderInteractor = ImageLoaderAdapter(imageLoader: TheDogAPIInteractor(client: networkClient),
                                                                  cacheLoader: ImageCacheLoader(baseDirectory: .applicationSupportDirectory))
    private static let searchBreedsInteractor = TheDogAPIInteractor(client: networkClient)
    
    static func makeCuteDogsListView(navigationController: UINavigationController) -> CuteDogsListViewController {
        
        let router = CuteDogsListRouter(navigationController: navigationController)
        let presenter = CuteDogsListPresenter(dogInteractor: dogBreedsInteractor,
                                              imageLoaderInteractor: imageLoaderInteractor,
                                              router: router,
                                              pageSize: 20,
                                              pageNumber: 0,
                                              fetchedAll: false)
        let cuteDogsViewController = CuteDogsListViewController(presenter: presenter)
        return cuteDogsViewController
    }
    
    static func makeCuteDogDetailView(cuteDog: CuteDog) -> CuteDogDetailViewController {
        
        let presenter = CuteDogDetailPresenter(cuteDog: cuteDog)
        let cuteDogDetailViewController = CuteDogDetailViewController(presenter: presenter)
        return cuteDogDetailViewController
    }
    
    static func makeSearchCuteDog(navigationController: UINavigationController) -> SearchCuteDogViewController {
        
        let router = SearchCuteDogsResultRouter(navigationController: navigationController)
        let presenter = SearchCuteDogsResultPresenter(searchInteractor: searchBreedsInteractor, router: router)
        let searchViewController = SearchCuteDogViewController(presenter: presenter)
        
        return searchViewController
    }
    
    static func makeTabBar() -> MainTabBarController {
        
        let customTabBar = MainTabBarController()
        customTabBar.makeListView = AppFactory.makeCuteDogsListView(navigationController:)
        customTabBar.makeSearchView = AppFactory.makeSearchCuteDog(navigationController:)
        return customTabBar
    }
}
