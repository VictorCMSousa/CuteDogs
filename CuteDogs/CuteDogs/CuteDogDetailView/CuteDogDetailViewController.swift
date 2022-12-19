//
//  CuteDogDetailViewController.swift
//  CuteDogs
//
//  Created by Victor Sousa on 19/12/2022.
//

import UIKit

final class CuteDogDetailViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cute Dogs Details"
        
    }
}
