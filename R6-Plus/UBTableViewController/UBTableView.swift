//
//  UBTableView.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 14/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

protocol UBTableView: class {
    
    func startLoading()
    func stopLoading()
    func registerCells(_ cells: [NibRegistrableTableViewCell.Type])
    func reloadTableView()
    func setCells(_ cells: [CellComponent], isLoadMore: Bool)
    func addRefreshControl()
    func setEmptyMessageIfNeeded(_ message: String) 
}
