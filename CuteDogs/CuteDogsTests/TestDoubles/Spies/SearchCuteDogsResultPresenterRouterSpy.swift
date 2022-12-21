//
//  SearchCuteDogsResultPresenterRouterSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

@testable import CuteDogs

final class SearchCuteDogsResultPresenterRouterSpy: SearchCuteDogsResultPresenterRouter {

    var wantToShowDetailsInput = [CuteDog]()
    func wantToShowDetails(of cuteDog: CuteDog) {
        wantToShowDetailsInput.append(cuteDog)
    }
}
