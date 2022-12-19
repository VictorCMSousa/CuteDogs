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
    
    static func makeCuteDogsListView() -> CuteDogsListViewController {
        
        let presenter = CuteDogsListPresenter(dogInteractor: dogBreedsInteractor,
                                              imageLoaderInteractor: imageLoaderInteractor,
                                              pageSize: 20,
                                              pageNumber: 0,
                                              fetchedAll: false)
        let cuteDogsViewController = CuteDogsListViewController(presenter: presenter)
        return cuteDogsViewController
    }
}
