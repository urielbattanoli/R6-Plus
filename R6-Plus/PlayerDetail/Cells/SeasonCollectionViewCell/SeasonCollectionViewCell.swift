//
//  SeasonCollectionViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 12/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class SeasonCollectionViewCell: NibRegistrableCollectionViewCell {

    @IBOutlet private weak var seasonIconImageView: UIImageView!
    @IBOutlet private weak var seasonTitleLabel: UILabel!
}

extension SeasonCollectionViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any) {
        guard let data = data as? SeasonCellData else { return }
        seasonIconImageView.image = data.iconImage
        seasonTitleLabel.text = data.title
    }
}
