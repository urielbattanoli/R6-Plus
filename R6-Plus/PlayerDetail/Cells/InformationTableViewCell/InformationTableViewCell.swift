//
//  InformationTableViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 07/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class InformationTableViewCell: NibRegistrableTableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
}

// MARK: - DynamicCellComponent
extension InformationTableViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any) {
        guard let data = data as? InformationCellData else { return }
        titleLabel.text = data.title
        descriptionLabel.text = data.description
    }
}
