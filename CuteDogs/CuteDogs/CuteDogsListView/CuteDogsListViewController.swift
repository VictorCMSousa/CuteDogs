//
//  CuteDogsListViewController.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import UIKit

protocol CuteDogsListViewControllerPresenter {
    
}

final class CuteDogsListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var listStyleToggleButton: UIButton!
    
    private let presenter: CuteDogsListViewControllerPresenter
    
    init(presenter: CuteDogsListViewControllerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onStyleToggle(_ sender: Any) {
        print("CuteDogsListViewController - onStyleToggle")
    }
    @IBAction func onSortButton(_ sender: Any) {
        print("CuteDogsListViewController - onSortButton")
    }
}

