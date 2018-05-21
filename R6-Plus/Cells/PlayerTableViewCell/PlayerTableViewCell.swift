//
//  PlayerTableViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 17/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class PlayerTableViewCell: NibRegistrableTableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileNameLabel: UILabel!
    @IBOutlet private weak var skillPointLabel: UILabel!
    @IBOutlet private weak var rankingImageView: UIImageView!
    
    // MARK: - Functions
    func fillData(_ data: PlayerCellData) {
        profileImageView.loadImage(data.imageUrl)
        profileNameLabel.text = data.name
        skillPointLabel.text = data.skillPoint
        rankingImageView.image = data.ranking.image
    }
}
