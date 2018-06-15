//
//  ComparisonHeaderTableViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 10/06/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class ComparisonHeaderTableViewCell: NibRegistrableTableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var leftPlayerImageView: UIImageView!
    @IBOutlet private weak var leftPlayerNameLabel: UILabel!
    @IBOutlet private weak var rightPlayerImageView: UIImageView!
    @IBOutlet private weak var rightPlayerNameLabel: UILabel!
}

// MARK: - DynamicCellComponent
extension ComparisonHeaderTableViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any) {
        guard let data = data as? ComparisonHeaderViewData else { return }
        
        leftPlayerImageView.loadImage(data.leftPlayerImageUrl)
        leftPlayerNameLabel.text = data.leftPlayerName
        rightPlayerImageView.loadImage(data.rightPlayerImageUrl)
        rightPlayerNameLabel.text = data.rightPlayerName
    }
}
