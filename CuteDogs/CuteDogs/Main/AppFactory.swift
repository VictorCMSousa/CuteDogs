//
//  AppFactory.swift
//  CuteDogs
//
//  Created by Victor Sousa on 19/12/2022.
//

import UIKit
import CoreData

final class AppFactory {
    
    private static let appSession = URLSession(configuration: .default)
    private static let networkClient = NetworkClient(session: appSession)
    private static let dogBreedsInteractor = TheDogAPIInteractor(client: networkClient, pageSize: 20, pageNumber: 0)
    private static let imageLoaderInteractor = ImageLoaderAdapter(imageLoader: dogBreedsInteractor,
                                                                  cacheLoader: ImageCacheLoader(baseDirectory: .cachesDirectory))
    private static let searchBreedsInteractor = TheDogAPIInteractor(client: networkClient)
    
    private static let coreData = try? CoreDataCuteDogStore(storeURL: NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("CuteDogs.sqlite"))
    private static let storageIntactor = LocalCuteDogInteractor(store: coreData)
    private static let cacheAdapterDogBreedInteractor = CuteDogLoaderCacheInteractorAdapter(remoteInteractor: dogBreedsInteractor,
                                                                                            cacheInteractor: storageIntactor)
    
    static func makeCuteDogsListView(navigationController: UINavigationController) -> CuteDogsListViewController {
        
        let router = CuteDogsListRouter(navigationController: navigationController)
        let presenter = CuteDogsListPresenter(dogInteractor: cacheAdapterDogBreedInteractor,
                                              imageLoaderInteractor: imageLoaderInteractor,
                                              router: router)
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
