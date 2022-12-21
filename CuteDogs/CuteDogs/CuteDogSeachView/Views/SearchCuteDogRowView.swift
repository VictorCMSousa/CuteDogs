//
//  SeachCuteDogRowView.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import UIKit

struct SeachCuteDogRowViewConfiguration {
    
    let id: String
    let name: String
    let group: String
    let origin: String
}

final class SearchCuteDogRowView: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    
    func setup(config: SeachCuteDogRowViewConfiguration) {
        
        nameLabel.text = config.name
        categoryLabel.text = config.group
        originLabel.text = config.origin
    }
}
