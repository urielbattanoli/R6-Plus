//
//  InformationTableViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 07/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class InformationTableViewCell: NibRegistrableTableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func fillData(_ data: InformationCellData) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
    }
}
