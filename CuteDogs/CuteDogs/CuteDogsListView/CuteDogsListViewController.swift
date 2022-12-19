//
//  CuteDogsListViewController.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import UIKit

protocol CuteDogsListViewControllerPresenter {
    
    func loadMoreDogBreeds(completion: @escaping (Result<[CuteDogsCellConfiguration], ApiError>) -> ())
    func load(imageURL: URL, completion: @escaping (UIImage?) -> ())
    func cancelLoad(imageURL: URL)
}

struct CuteDogsCellConfiguration: Hashable, Comparable {
    
    let id: String
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
        
        title = "Cute Dogs"
        
        collectionView.register(UINib(nibName:"CuteDogsListCellView", bundle: nil), forCellWithReuseIdentifier: listCellId)
        collectionView.register(UINib(nibName:"CuteDogsGridCellView", bundle: nil), forCellWithReuseIdentifier: gridCellId)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = listCVLayout
        
        presenter.loadMoreDogBreeds { [weak self] result in
            
            switch result {
            case .success(let configs):
                self?.setup(configs: configs)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setup(configs: [CuteDogsCellConfiguration]) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(configs)
        dataSource.apply(snapshot, animatingDifferences: true)
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
        var snapshot = dataSource.snapshot()
        let sortedElements = snapshot.itemIdentifiers(inSection: .main).sorted()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(sortedElements)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CuteDogsListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1 {
            presenter.loadMoreDogBreeds { [weak self] result in
                
                switch result {
                case .success(let configs):
                    self?.render(configs: configs)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        if let cell = cell as? CellImageResource, let imageURL = cellController(at: indexPath)?.dogImageURL {
            presenter.load(imageURL: imageURL) { image in
                cell.render(image: image)
            }
        }
    }
    
    private func render(configs: [CuteDogsCellConfiguration]) {
        
        guard !configs.isEmpty else { return }
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(configs)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let imageURL = cellController(at: indexPath)?.dogImageURL {
            presenter.cancelLoad(imageURL: imageURL)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("CuteDogsListViewController didSelectItemAt \(cellController(at: indexPath)?.name)")
    }
    
    private func cellController(at indexPath: IndexPath) -> CuteDogsCellConfiguration? {
        dataSource.itemIdentifier(for: indexPath)
    }
    
}
