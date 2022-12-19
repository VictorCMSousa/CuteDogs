//
//  CuteDogsListRouter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 19/12/2022.
//

import UIKit

final class CuteDogsListRouter: CuteDogsListPresenterRouter {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func wantToShowDetails(of cuteDog: CuteDog) {
        let detailsViewController = AppFactory.makeCuteDogDetailView(cuteDog: cuteDog)
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
