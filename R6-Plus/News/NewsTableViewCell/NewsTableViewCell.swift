//
//  NewsTableViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 28/01/19.
//  Copyright © 2019 Mocka. All rights reserved.
//

import UIKit

class NewsTableViewCell: NibRegistrableTableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var cellBackgroundView: GradientView!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var mediaImageView: UIImageView!
    @IBOutlet private weak var mediaHeightConstraint: NSLayoutConstraint!
}

extension NewsTableViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any) {
        guard let data = data as? NewsCellData else { return }
        cellBackgroundView.colors = [#colorLiteral(red: 0.1058823529, green: 0.1450980392, blue: 0.1803921569, alpha: 1), #colorLiteral(red: 0.2125904904, green: 0.249248237, blue: 0.3033046109, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1450980392, blue: 0.1803921569, alpha: 1)]
        cellBackgroundView.setBlackShadow()
        cellBackgroundView.setCorner(value: 3)
        photoImageView.setAsCircle()
        photoImageView.loadImage(data.photoUrl)
        nameLabel.text = data.name
        dateLabel.text = "@\(data.screenName) - \(data.date)"
        messageLabel.text = data.message
        guard data.mediaHeight != 0 else {
            mediaImageView.image = nil
            mediaHeightConstraint.constant = 0
            return
        }
        var ratio = CGFloat(data.mediaWidth / data.mediaHeight)
        ratio = ratio == 0.0 ? 1 : ratio
        mediaHeightConstraint.constant = mediaImageView.frame.width / ratio
        mediaImageView.loadImage(data.mediaUrl)
    }
}
