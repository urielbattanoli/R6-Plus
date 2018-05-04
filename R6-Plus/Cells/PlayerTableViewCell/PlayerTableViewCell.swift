//
//  PlayerTableViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 14/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class PlayerTableViewCell: NibRegistrableTableViewCell {
    
    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var backgroundImageView: UIImageView?
    @IBOutlet private weak var positionLabel: UILabel?
    @IBOutlet private weak var nicknameLabel: UILabel?
    @IBOutlet private weak var skillPointLabel: UILabel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundImageView?.image = nil
        positionLabel?.text = nil
        nicknameLabel?.text = nil
        skillPointLabel?.text = nil
    }
    
    func fillData(data: PlayerViewData) {
        cellBackgroundView.setBlackShadow()
        backgroundImageView?.loadImage(data.playerImage)
        positionLabel?.text = data.position
        nicknameLabel?.text = data.nickName
        skillPointLabel?.text = data.skillPoint
    }
}
