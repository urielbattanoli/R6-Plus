//
//  AliasesCollectionViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 12/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class AliasesCollectionViewCell: NibRegistrableCollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var lineLeftView: UIView!
    @IBOutlet private weak var centerCircleView: UIView! {
        didSet {
            centerCircleView.setAsCircle()
        }
    }
    @IBOutlet private weak var lineRightView: UIView!
    
    // MARK: - Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lineRightView.isHidden = false
        lineLeftView.isHidden = false
    }
}

// MARK: - DynamicCellComponent
extension AliasesCollectionViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any) {
        guard let data = data as? AliasesCellData else { return }
        
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        lineLeftView.isHidden = data.hideLine == .left || data.hideLine == .both
        lineRightView.isHidden = data.hideLine == .right || data.hideLine == .both
    }
}
