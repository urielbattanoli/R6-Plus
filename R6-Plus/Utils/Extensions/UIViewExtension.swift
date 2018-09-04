//
//  UIViewExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 03/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

extension UIView {
    
    func setBlackShadow() {
        clipsToBounds = false
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.6
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    func setCorner(value: CGFloat) {
        layer.cornerRadius = value
        clipsToBounds = true
    }
    
    func setAsCircle() {
        setCorner(value: frame.width / 2)
    }
    
    func setGradient() {
        let gradient = RadialGradientLayer()
        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
        gradient.frame = bounds
    }
}

class RadialGradientLayer: CALayer {
    
    private var center: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    private var radius: CGFloat {
        return (bounds.width + bounds.height) / 2
    }
    
    override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        ctx.saveGState()
        let colorsSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [#colorLiteral(red: 0.2125904904, green: 0.249248237, blue: 0.3033046109, alpha: 1).cgColor, #colorLiteral(red: 0.1058823529, green: 0.1450980392, blue: 0.1803921569, alpha: 1).cgColor]
        guard let gradient = CGGradient(colorsSpace: colorsSpace, colors: colors as CFArray, locations: [0.0, 1.0]) else { return }
        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
}
