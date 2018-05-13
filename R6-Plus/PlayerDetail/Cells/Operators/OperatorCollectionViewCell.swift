//
//  OperatorCollectionViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 12/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

struct OperatorCellData {
    let image: UIImage
}

class OperatorCollectionViewCell: NibRegistrableCollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var iconImageView: UIImageView!
}

extension OperatorCollectionViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any) {
        guard let data = data as? OperatorCellData else { return }
        iconImageView.image = data.image
    }
}
