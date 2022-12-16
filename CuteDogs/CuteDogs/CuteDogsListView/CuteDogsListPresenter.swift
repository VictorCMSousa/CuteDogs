//
//  CuteDogsListPresenter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import Foundation


final class CuteDogsListPresenter: CuteDogsListViewControllerPresenter {
    
    private let docInteractor: DogBreedsInteractor
    
    init(docInteractor: DogBreedsInteractor) {
        
        self.docInteractor = docInteractor
    }
}
