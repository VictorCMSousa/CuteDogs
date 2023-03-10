//
//  CuteDogDetailViewController.swift
//  CuteDogs
//
//  Created by Victor Sousa on 19/12/2022.
//

import UIKit

protocol CuteDogDetailViewControllerPresenter {
    
    func makeViewConfig() -> CuteDogDetailViewConfiguration
}

struct CuteDogDetailViewConfiguration {
    
    let name: String
    let category: String
    let origin: String
    let temperament: String
}

final class CuteDogDetailViewController: UIViewController {
    
    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var breedCategoryLabel: UILabel!
    
    @IBOutlet weak var originStackView: UIStackView!
    @IBOutlet weak var breedOriginLabel: UILabel!
    
    @IBOutlet weak var temperamentStackView: UIStackView!
    @IBOutlet weak var breedTemperamentLabel: UILabel!
    
    private let presenter: CuteDogDetailViewControllerPresenter
    
    init(presenter: CuteDogDetailViewControllerPresenter) {
        
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = presenter.makeViewConfig()
        
        breedNameLabel.text = config.name
        
        categoryStackView.isHidden = config.category.isEmpty
        breedCategoryLabel.text = config.category
        
        originStackView.isHidden = config.origin.isEmpty
        breedOriginLabel.text = config.origin
        
        temperamentStackView.isHidden = config.temperament.isEmpty
        breedTemperamentLabel.text = config.temperament
        
    }
}
