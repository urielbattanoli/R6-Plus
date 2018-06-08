//
//  HeaderListView.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 07/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class HeaderListView: NibDesignable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func fillData(_ data: HeaderListViewData) {
        titleLabel.text = data.title
    }
}
