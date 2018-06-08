//
//  ComparisonInfoTableViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 08/06/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class ComparisonInfoTableViewCell: NibRegistrableTableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var leftInfoLabel: UILabel!
    @IBOutlet private weak var infoNameLabel: UILabel!
    @IBOutlet private weak var rightInfoLabel: UILabel!
    
    // MARK: - Functions
    private func setInfoColors(bestScore: BestScore) {
        let rightColor: UIColor
        let leftColor: UIColor
        switch bestScore {
        case .right:
            leftColor = .lightGray
            rightColor = .white
        case .left:
            leftColor = .white
            rightColor = .lightGray
        case .equal:
            rightColor = .white
            leftColor = .white
        }
        leftInfoLabel.textColor = leftColor
        rightInfoLabel.textColor = rightColor
    }
}

// MARK: - DynamicCellComponent
extension ComparisonInfoTableViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any) {
        guard let data = data as? ComparisonInfoData else { return }
        
        setInfoColors(bestScore: data.bestScore)
        leftInfoLabel.text = data.leftInfo
        infoNameLabel.text = data.infoName
        rightInfoLabel.text = data.rightInfo
    }
}
