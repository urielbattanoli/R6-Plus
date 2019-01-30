//
//  GradientView.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 08/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//
import UIKit

@IBDesignable
class GradientView: UIView {
    
    let gradientName = "gradientLayer"
    
    @IBInspectable var start: CGPoint = CGPoint(x: 0, y: 0) {
        didSet { configureGradient() }
    }
    
    @IBInspectable var end: CGPoint = CGPoint(x: 0, y: 1) {
        didSet { configureGradient() }
    }
    
    @IBInspectable var colors: [UIColor] = [.black,.clear] {
        didSet { configureGradient() }
    }
    
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override var bounds: CGRect {
        didSet { configureGradient() }
    }
    
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradient()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureGradient()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureGradient()
    }
    
    func configureGradient() {
        self.layer.frame = bounds
        layer.setNeedsDisplay()
        gradientLayer.startPoint = start
        gradientLayer.endPoint = end
        gradientLayer.colors = colors.compactMap{$0.cgColor}
    }
}
