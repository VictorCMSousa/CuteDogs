//
//  CuteDogsGridCellView.swift
//  CuteDogs
//
//  Created by Victor Sousa on 17/12/2022.
//

import UIKit

final class CuteDogsGridCellView: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    
    func setup(config: CuteDogsCellConfiguration) {
        
        nameLabel.text = config.name
        
    }
}
