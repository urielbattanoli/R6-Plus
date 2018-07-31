//
//  MatchTableViewCell.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 30/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class MatchTableViewCell: NibRegistrableTableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var tournamentNameLabel: UILabel!
    @IBOutlet private weak var teamAImageView: UIImageView!
    @IBOutlet private weak var teamANameLabel: UILabel!
    @IBOutlet private weak var matchTimeLabel: UILabel!
    @IBOutlet private weak var teamBImageView: UIImageView!
    @IBOutlet private weak var teamBNameLabel: UILabel!
    @IBOutlet private weak var liveView: UIView!
    @IBOutlet private weak var liveLabel: UILabel!
    @IBOutlet private weak var liveCircleView: UIView! {
        didSet {
            liveCircleView.setAsCircle()
        }
    }
    
    private func startAnimating() {
        liveView.alpha = 1
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       options: [.repeat, .autoreverse],
                       animations: { [weak self] in
                        self?.liveView.alpha = 0
            }, completion: nil)
    }
}

// MARK: - DynamicCellComponent
extension MatchTableViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any) {
        guard let data = data as? MatchCellData else { return }
        cellBackgroundView.setGradient()
        cellBackgroundView.setBlackShadow()
        cellBackgroundView.setCorner(value: 3)
        tournamentNameLabel.text = data.tournamentName
        teamAImageView.loadImage(data.teamAImageUrl)
        teamANameLabel.text = data.teamAName
        matchTimeLabel.text = data.matchTime
        teamBImageView.loadImage(data.teamBImageUrl)
        teamBNameLabel.text = data.teamBName
        if data.isLive {
            startAnimating()
        }
    }
}
