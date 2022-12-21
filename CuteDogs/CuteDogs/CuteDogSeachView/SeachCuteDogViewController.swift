//
//  SeachCuteDogViewController.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import UIKit

protocol CitySearchResultView: UIViewController, UISearchResultsUpdating { }

final class SeachCuteDogViewController: UITableViewController, CitySearchResultView {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
