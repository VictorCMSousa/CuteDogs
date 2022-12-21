//
//  SearchCuteDogsResultRouter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import UIKit

final class SearchCuteDogsResultRouter: SearchCuteDogsResultPresenterRouter {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func wantToShowDetails(of cuteDog: CuteDog) {
        let detailsViewController = AppFactory.makeCuteDogDetailView(cuteDog: cuteDog)
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
