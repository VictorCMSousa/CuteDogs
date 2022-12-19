//
//  CuteDogDetailViewControllerPresenterSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

@testable import CuteDogs

final class CuteDogDetailViewControllerPresenterSpy: CuteDogDetailViewControllerPresenter {
    
    var makerViewConfig: () -> (CuteDogDetailViewConfiguration) = {
        .empty
    }
    func makeViewConfig() -> CuteDogDetailViewConfiguration {
        makerViewConfig()
    }
}
