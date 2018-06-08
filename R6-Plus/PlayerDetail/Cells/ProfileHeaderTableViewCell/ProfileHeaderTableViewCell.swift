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
}

// MARK: - DynamicCellComponent
extension ProfileHeaderTableViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any) {
        guard let data = data as? ProfileHeaderCellData else { return }
        profileImageView.loadImage(data.imageUrl)
    }
}
