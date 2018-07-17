//
//  OperatorDetailViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 13/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class OperatorDetailViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var backgroundView: UIControl!
    @IBOutlet private weak var tableBackgroundView: UIView! {
        didSet {
            tableBackgroundView.setCorner(value: 3)
        }
    }
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var panGestureRecognizer: UIPanGestureRecognizer!
    
    // MARK: - Properties
    private var sections: [SectionComponent] = []
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    // MARK: - Life cycle
    init(sections: [SectionComponent]) {
        self.sections = sections
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    // MARK: - Functions
    private func setupTableView() {
        tableView.register(InformationTableViewCell.nib, forCellReuseIdentifier: InformationTableViewCell.reuseId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.estimatedSectionHeaderHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    private func dismissViewController() {
        dismiss(animated: true)
    }
    
    // MARK: - IBAction
    @IBAction private func backgroundViewTouched(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction private func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: backgroundView?.window)
        
        if sender.state == .began {
            initialTouchPoint = touchPoint
        } else if sender.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                backgroundView.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: backgroundView.frame.size.width, height: backgroundView.frame.size.height)
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                dismissViewController()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.backgroundView.frame = CGRect(x: 0, y: 0, width: self.backgroundView.frame.size.width, height: self.backgroundView.frame.size.height)
                })
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension OperatorDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let component = sections[indexPath.section].cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: component.reuseId)
        (cell as? DynamicCellComponent)?.updateUI(with: component.data as Any)
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension OperatorDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderListView()
        view.fillData(HeaderListViewData(title: sections[section].title ?? "",
                                         alignment: .left,
                                         color: .white))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
}
