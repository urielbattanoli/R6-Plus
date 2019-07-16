//
//  BannerViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 20/09/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class BannerViewController: UIViewController {
    
    private(set) var bannerView: UIView!
    private let window = BannerWindow()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self
    }
    
    override func loadView() {
        let view = UIView()
        let yPosition = window.frame.maxY - 150
        let bannerView = UIView(frame: CGRect(x: window.frame.minX, y: yPosition, width: window.frame.width, height: 50))
        bannerView.backgroundColor = .red
        view.addSubview(bannerView)
        self.view = view
        self.bannerView = bannerView
        window.bannerView = bannerView
    }
}

private class BannerWindow: UIWindow {
    
    var bannerView: UIView?
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let bannerView = bannerView else { return false }
        let viewPoint = convert(point, to: bannerView)
        return bannerView.point(inside: viewPoint, with: event)
    }
}
