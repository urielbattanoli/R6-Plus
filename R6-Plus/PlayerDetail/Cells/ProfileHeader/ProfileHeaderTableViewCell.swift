//
//  ProfileHeaderTableViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 06/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: NibRegistrableTableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Function
    func fillData(_ data: ProfileHeaderCellData) {
        profileImageView.loadImage(data.imageUrl)
        nameLabel.text = data.name
    }
}
