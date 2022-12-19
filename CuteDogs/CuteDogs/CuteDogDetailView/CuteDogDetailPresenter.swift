//
//  CuteDogDetailPresenter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 19/12/2022.
//

import Foundation

final class CuteDogDetailPresenter: CuteDogDetailViewControllerPresenter {

    private let cuteDog: CuteDog
    
    init(cuteDog: CuteDog) {
        self.cuteDog = cuteDog
    }
    
    func makeViewConfig() -> CuteDogDetailViewConfiguration {
        .init(name: cuteDog.breedName,
              category: cuteDog.breedGroup,
              origin: cuteDog.origin,
              temperament: cuteDog.breedTemperament)
    }
    
}
