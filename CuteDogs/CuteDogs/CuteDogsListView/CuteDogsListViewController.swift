//
//  CuteDogsListViewController.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import UIKit

protocol CuteDogsListViewControllerPresenter {
    
}

struct CuteDogsCellConfiguration: Hashable, Comparable {
    
    let id: Int
    let name: String
    let dogImageURL: URL?
    
    static func < (lhs: CuteDogsCellConfiguration, rhs: CuteDogsCellConfiguration) -> Bool {
        lhs.name < rhs.name
    }
    
}

final class CuteDogsListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var listStyleToggleButton: UIButton!
    
    private let presenter: CuteDogsListViewControllerPresenter
    
    enum Section {
        case main
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, CuteDogsCellConfiguration>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CuteDogsCellConfiguration>
    
    private let listCellId: String = "listCellId"
    private let gridCellId: String = "gridCellId"
    
    private lazy var dataSource: DataSource = {
        .init(collectionView: collectionView) { [weak self] (collectionView, indexPath, config) in
            guard let self else { return UICollectionViewCell() }
            if self.isListView {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.listCellId,
                                                                    for: indexPath) as? CuteDogsListCellView else {
                    return UICollectionViewCell()
                }
                cell.setup(config: config)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.gridCellId,
                                                                    for: indexPath) as? CuteDogsGridCellView else {
                    return UICollectionViewCell()
                }
                cell.setup(config: config)
                return cell
            }
        }
    }()
    
    private var isListView: Bool = true
    
    private lazy var listCVLayout: UICollectionViewFlowLayout = {

        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        collectionFlowLayout.itemSize = CGSize(width: collectionView.frame.width-32, height: 160)
        collectionFlowLayout.minimumInteritemSpacing = 8
        collectionFlowLayout.minimumLineSpacing = 8
        collectionFlowLayout.scrollDirection = .vertical
        return collectionFlowLayout
    }()

    private lazy var gridCVLayout: UICollectionViewFlowLayout = {
        
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 20, left: 8, bottom: 8, right: 8)
        let cellWidth = 160.0
        let itemPerLine = (collectionView.frame.width/cellWidth).rounded()
        collectionFlowLayout.itemSize = CGSize(width: (collectionView.frame.width/itemPerLine)-16 , height: 200)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.minimumLineSpacing = 8
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
        
        collectionView.register(UINib(nibName:"CuteDogsListCellView", bundle: nil), forCellWithReuseIdentifier: listCellId)
        collectionView.register(UINib(nibName:"CuteDogsGridCellView", bundle: nil), forCellWithReuseIdentifier: gridCellId)
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = listCVLayout
        apply()
    }
    
    func apply() {
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        let configs: [CuteDogsCellConfiguration] = [.init(id: 1, name: "Siberian Husky", dogImageURL: nil),
                                                    .init(id: 2, name: "Smooth Fox Terrier", dogImageURL: nil),
                                                    .init(id: 3, name: "Rat Terrier", dogImageURL: nil),
                                                    .init(id: 4, name: "Belgian Malinoise", dogImageURL: nil),
                                                    .init(id: 5, name: "Bedlington Terrier", dogImageURL: nil),
                                                    .init(id: 6, name: "Australian Kelpie", dogImageURL: nil),
                                                    .init(id: 7, name: "Cairn Terrier", dogImageURL: nil),
                                                    .init(id: 8, name: "Dalmatian", dogImageURL: nil),
                                                    .init(id: 9, name: "Cairn Terrier", dogImageURL: nil),
                                                    .init(id: 10, name: "Dalmatian", dogImageURL: nil),
                                                    .init(id: 11, name: "Cardigan Welsh Corgi", dogImageURL: nil),
         ]
        snapshot.appendItems(configs)
        dataSource.apply(snapshot, animatingDifferences: false)
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
        var snapshot = dataSource.snapshot()
        let sortedElements = snapshot.itemIdentifiers(inSection: .main).sorted()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(sortedElements)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: UICollectionViewDiffableDataSource

extension CuteDogsListViewController {
    
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        indexPaths.forEach { indexPath in
//            let dsp = cellController(at: indexPath)?.dataSourcePrefetching
//            dsp?.collectionView(collectionView, prefetchItemsAt: [indexPath])
//        }
//    }
  
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataSource.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if isListView {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellId, for: indexPath) as? CuteDogsListCellView else {
//                return UICollectionViewCell()
//            }
//            cell.setup(config: dataSource[indexPath.item])
//            return cell
//        } else {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellId, for: indexPath) as? CuteDogsGridCellView else {
//                return UICollectionViewCell()
//            }
//            cell.setup(config: dataSource[indexPath.item])
//            return cell
//        }
//    }
//
//    private func cellController(at indexPath: IndexPath) -> CuteDogsCellConfiguration? {
//        dataSource.itemIdentifier(for: indexPath)
//    }
}
