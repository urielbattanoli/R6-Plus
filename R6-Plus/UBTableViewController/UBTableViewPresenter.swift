//
//  UBTableViewPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 24/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

protocol UBtableViewPresenter: class {
    
    func loadMoreInfo()
    func refreshControlAction()
    func attachView(_ view: UBTableView)
    func viewdidAppear()
}
