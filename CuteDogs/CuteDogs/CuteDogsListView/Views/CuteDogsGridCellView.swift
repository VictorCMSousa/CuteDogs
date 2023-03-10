//
//  CuteDogsGridCellView.swift
//  CuteDogs
//
//  Created by Victor Sousa on 17/12/2022.
//

import UIKit

final class CuteDogsGridCellView: UICollectionViewCell, CellImageResource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    
    func setup(config: CuteDogsCellConfiguration) {
        
        nameLabel.text = config.name
        
    }
    
    func render(image: UIImage?) {
        dogImageView.image = image ?? UIImage(named: "cute-placehold")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dogImageView.image = UIImage()
    }
}
