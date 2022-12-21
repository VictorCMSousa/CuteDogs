//
//  SearchCuteDogViewController.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import UIKit


protocol SearchResultViewControllerPresenter {
    
    func search(breedName: String, completion: @escaping (Result<[SeachCuteDogRowViewConfiguration], ApiError>) -> ())
    func wantToShowDetails(id: String)
}

final class SearchCuteDogViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let presenter: SearchResultViewControllerPresenter
    private var rowsConfigs = [SeachCuteDogRowViewConfiguration]()
    private let searchController: UISearchController
    private let waitingToRequest: Double
    
    init(presenter: SearchResultViewControllerPresenter,
         searchController:UISearchController = UISearchController(searchResultsController: nil),
         waitingToRequest: Double = 0.5) {
        
        self.presenter = presenter
        self.searchController = searchController
        self.waitingToRequest = waitingToRequest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchCuteDogRowView.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        
        searchController.obscuresBackgroundDuringPresentation = true
        
        searchController.searchBar.tintColor = .systemMint
        searchController.obscuresBackgroundDuringPresentation = false
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .attributedPlaceholder = NSAttributedString(string: "Search",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        searchController.searchBar.barStyle = UIBarStyle.default
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = .black

        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(filterContentForSearchText(searchController:)),
                                               object: searchController)
        self.perform(#selector(filterContentForSearchText(searchController:)), with: searchController, afterDelay: waitingToRequest)
    }
    
    @objc private func filterContentForSearchText(searchController: UISearchController) {
        guard let breedName = searchController.searchBar.text, !breedName.isEmpty else { return }
        presenter.search(breedName: breedName, completion: { [weak self] result in
            
            switch result {
            case let .success(cuteDogs):
                self?.rowsConfigs = cuteDogs
                self?.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        })
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate

extension SearchCuteDogViewController: UITableViewDataSource & UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowsConfigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(SearchCuteDogRowView.self, indexPath: indexPath) else { return UITableViewCell()  }
        cell.setup(config: rowsConfigs[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let config = rowsConfigs[indexPath.row]
        presenter.wantToShowDetails(id: config.id)
    }
}
