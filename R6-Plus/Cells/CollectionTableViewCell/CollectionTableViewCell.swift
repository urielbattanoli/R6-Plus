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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var items: [CellComponent] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Functions
    func fillData(_ data: CollectionCellData) {
        titleLabel.text = data.title
        registerCellClasses(data.cellsToRegister)
        items = data.items
    }
    
    private func registerCellClasses(_ cellClassesToRegister: [NibRegistrableCollectionViewCell.Type]) {
        cellClassesToRegister.forEach { collectionView.registerNib(for: $0) }
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
