//
//  CuteDogsListViewController.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import UIKit

protocol CuteDogsListViewControllerPresenter {
    
}

struct CuteDogsCellConfiguration {
    
    let name: String
    let dogImageURL: URL?
}

final class CuteDogsListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var listStyleToggleButton: UIButton!
    
    private let presenter: CuteDogsListViewControllerPresenter
    
    private let listCellId: String = "listCellId"
    private let gridCellId: String = "gridCellId"
    private var isListView: Bool = true
    
    private var dataSource: [CuteDogsCellConfiguration] = []
    
    private lazy var listCVLayout: UICollectionViewFlowLayout = {

        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        collectionFlowLayout.itemSize = CGSize(width: collectionView.frame.width, height: 160)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.minimumLineSpacing = 20
        collectionFlowLayout.scrollDirection = .vertical
        return collectionFlowLayout
    }()

    private lazy var gridCVLayout: UICollectionViewFlowLayout = {
        
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionFlowLayout.itemSize = CGSize(width: (collectionView.frame.width - 20) / 2 , height: 200)
        collectionFlowLayout.minimumInteritemSpacing = 20
        collectionFlowLayout.minimumLineSpacing = 20
        return collectionFlowLayout
    }()
    
    init(presenter: CuteDogsListViewControllerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [.init(name: "Australian Kelpie", dogImageURL: nil), .init(name: "Belgian Malinois", dogImageURL: nil),
                      .init(name: "Bedlington Terrier", dogImageURL: nil), .init(name: "Belgian Malinoise", dogImageURL: nil),
                      .init(name: "Bedlington Terrier", dogImageURL: nil), .init(name: "Australian Kelpie", dogImageURL: nil),
                      .init(name: "Cairn Terrier", dogImageURL: nil), .init(name: "Dalmatian", dogImageURL: nil),
                      .init(name: "Cairn Terrier", dogImageURL: nil), .init(name: "Dalmatian", dogImageURL: nil),
                      .init(name: "Cardigan Welsh Corgi", dogImageURL: nil), .init(name: "Australian Kelpie", dogImageURL: nil),
                      .init(name: "Cardigan Welsh Corgi", dogImageURL: nil), .init(name: "Australian Kelpie", dogImageURL: nil),
                      .init(name: "Scottish Terrier", dogImageURL: nil), .init(name: "Siberian Husky", dogImageURL: nil),
                      .init(name: "Scottish Terrier", dogImageURL: nil), .init(name: "Siberian Husky", dogImageURL: nil),
        ]
        
        collectionView.register(UINib(nibName:"CuteDogsListCellView", bundle: nil), forCellWithReuseIdentifier: listCellId)
        collectionView.register(UINib(nibName:"CuteDogsGridCellView", bundle: nil), forCellWithReuseIdentifier: gridCellId)
        collectionView.dataSource = self
        collectionView.collectionViewLayout = listCVLayout
    }
    
    private var waitStyleTransaction = false
    @IBAction func onStyleToggle(_ sender: Any) {

        guard !waitStyleTransaction else { return }
        waitStyleTransaction = true
        let buttonImage = isListView ? UIImage(systemName: "rectangle.grid.1x2") : UIImage(systemName: "square.grid.2x2")
        listStyleToggleButton.setImage(buttonImage, for: .normal)
        isListView.toggle()
        collectionView.startInteractiveTransition(to: isListView ? listCVLayout : gridCVLayout) { [weak self] _,_ in
            self?.waitStyleTransaction = false
        }
        collectionView.finishInteractiveTransition()
        collectionView.reloadData()
    }
    
    @IBAction func onSortButton(_ sender: Any) {
        print("CuteDogsListViewController - onSortButton")
    }
}

// MARK: UICollectionViewDataSource

extension CuteDogsListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isListView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellId, for: indexPath) as? CuteDogsListCellView else {
                return UICollectionViewCell()
            }
            cell.setup(config: dataSource[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellId, for: indexPath) as? CuteDogsGridCellView else {
                return UICollectionViewCell()
            }
            cell.setup(config: dataSource[indexPath.item])
            return cell
        }
    }
}
