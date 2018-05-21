//
//  MenuHeaderMain.swift
//  Makadu
//
//  Created by Matheus Alberton on 14/02/18.
//  Copyright © 2018 Makadu. All rights reserved.
//

import UIKit

protocol MenuHeaderMainDelegate {
    func button(_ button: UIButton, didChangeToPosition position: Int)
}

class MenuHeaderMain: NibDesignable {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var constraintButtonBorderLeftSpace: NSLayoutConstraint!
    @IBOutlet private weak var constraintButtonBorderWidth: NSLayoutConstraint!

    var delegate: MenuHeaderMainDelegate?
    private var itemTextColor: UIColor = .white
    private var currentItem: Int = 0
    var items: [String] = [] {
        didSet {
            setData()
        }
    }

    private func setData() {
        for index in 0..<items.count {
            let item = items[index]

            let headerItem = MenuHeaderMainItem()
            headerItem.buttonTitle = item.uppercased()
            headerItem.button.setTitleColor(itemTextColor, for: .normal)
            headerItem.button.tag = index
            headerItem.button.addTarget(self, action: #selector(clickMenu(_:)), for: .touchUpInside)
            headerItem.backgroundColor = .clear

            stackView.addArrangedSubview(headerItem)
        }
        
        animateMenu(withPosition: 0)
    }

    func animateMenu(withPosition position: Int) {
        var currentView: MenuHeaderMainItem!
        for index in 0..<stackView.arrangedSubviews.count {
            let view = stackView.arrangedSubviews[index] as! MenuHeaderMainItem

            if index == position {
                currentView = view
            }
        }

        layoutIfNeeded()

        let viewPosition = currentView.frame.origin.x + currentView.frame.width + scrollView.contentOffset.x

        if viewPosition > scrollView.frame.width && position > currentItem {
            var newPosition: CGFloat = 0

            if position == stackView.arrangedSubviews.count-1 {
                newPosition = scrollView.contentSize.width - scrollView.bounds.size.width
            } else {
                newPosition = scrollView.contentOffset.x + currentView.frame.width
            }
    
            scrollView.setContentOffset(CGPoint(x: newPosition, y: 0), animated: true)
        } else if viewPosition < scrollView.contentSize.width && position < currentItem {
            var newPosition = scrollView.contentOffset.x - currentView.frame.width
            if newPosition < 0 {
                newPosition = 0
            }

            scrollView.setContentOffset(CGPoint(x: newPosition, y: 0), animated: true)
        }

        UIView.animate(withDuration: 0.25) {
            self.constraintButtonBorderLeftSpace.constant = currentView.frame.origin.x + 8
            self.constraintButtonBorderWidth.constant = currentView.frame.width - 16

            self.layoutIfNeeded()
        }

        borderView.isHidden = false
        currentItem = position
    }

    @IBAction private func clickMenu(_ sender: UIButton) {
        animateMenu(withPosition: sender.tag)
        delegate?.button(sender, didChangeToPosition: sender.tag)
    }
}
