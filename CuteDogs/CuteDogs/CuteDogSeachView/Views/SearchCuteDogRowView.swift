//
//  SeachCuteDogRowView.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import UIKit

struct SearchCuteDogRowViewConfiguration: Equatable {
    
    let id: String
    let name: String
    let group: String
    let origin: String
}

final class SearchCuteDogRowView: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryStack: UIStackView!
    @IBOutlet weak var originStack: UIStackView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    
    func setup(config: SearchCuteDogRowViewConfiguration) {
        
        nameLabel.text = config.name
        categoryLabel.text = config.group
        categoryStack.isHidden = config.group.isEmpty
        originLabel.text = config.origin
        originStack.isHidden = config.origin.isEmpty
    }
}
