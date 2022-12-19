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
    private static let imageLoaderInteractor = ImageLoaderAdapter(imageLoader: dogBreedsInteractor,
                                                                  cacheLoader: ImageCacheLoader())
    
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
}
