//
//  CollectionCellData.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 06/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import CoreGraphics

struct CollectionCellData {
    let collectionHeight: CGFloat
    let cellsToRegister: [NibRegistrableCollectionViewCell.Type]
    let items: [CellComponent]
}
