//
//  CuteDogsListPresenterRouterSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

@testable import CuteDogs

final class CuteDogsListPresenterRouterSpy: CuteDogsListPresenterRouter {

    var wantToShowDetailsInput = [CuteDog]()
    func wantToShowDetails(of cuteDog: CuteDog) {
        wantToShowDetailsInput.append(cuteDog)
    }
}
