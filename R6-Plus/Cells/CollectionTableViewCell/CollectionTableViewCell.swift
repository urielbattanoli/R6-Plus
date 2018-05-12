//
//  CollectionTableViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 06/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class CollectionTableViewCell: NibRegistrableTableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    // MARK: - Properties
    private var items: [CellComponent] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Functions
    private func registerCellClasses(_ cellClassesToRegister: [NibRegistrableCollectionViewCell.Type]) {
        cellClassesToRegister.forEach { collectionView.registerNib(for: $0) }
    }
}

// MARK: - DynamicCellComponent
extension CollectionTableViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any) {
        guard let data = data as? CollectionCellData else { return }
        registerCellClasses(data.cellsToRegister)
        collectionHeightConstraint.constant = data.collectionHeight
        items = data.items
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseId, for: indexPath)
        if let data = item.data, let dynamicCell = cell as? DynamicCellComponent {
            dynamicCell.updateUI(with: data)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items[indexPath.row].selectionHandler?()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
