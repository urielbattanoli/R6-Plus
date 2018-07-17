//
//  CellComponent.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 06/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct SectionComponent {
    let title: String?
    let cells: [CellComponent]
}

class CellComponent {
    let reuseId: String
    var data: Any?
    let selectionHandler: (() -> Void)?
    
    init(reuseId: String, data: Any? = nil, selectionHandler: (() -> Void)? = nil) {
        self.reuseId = reuseId
        self.data = data
        self.selectionHandler = selectionHandler
    }
}

protocol DynamicCellComponent: NibRegistrableView {
    func updateUI(with data: Any)
}
