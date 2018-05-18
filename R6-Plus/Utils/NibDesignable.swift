//
//  NibDesignable.swift
//
//  Copyright (c) 2014 Morten Bøgh
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public protocol NibDesignableProtocol: NSObjectProtocol {
    /**
     Identifies the view that will be the superview of the contents loaded from
     the Nib. Referenced in setupNib().

     - returns: Superview for Nib contents.
     */
    var nibContainerView: UIView { get }
    // MARK: - Nib loading

    /**
     Identifies the view that will be the content loaded from
     the Nib. Referenced in setupNib().

     - returns: view with Nib contents.
     */
    var nibView: UIView? { get set }

    // MARK: - Nib loading

    /**
     Called to load the nib in setupNib().

     - returns: UIView instance loaded from a nib file.
     */
    func loadNib() -> UIView
    /**
     Called in the default implementation of loadNib(). Default is class name.

     - returns: Name of a single view nib file.
     */
    func nibName() -> String

    func awakeFromNib()
}

extension NibDesignableProtocol {
    // MARK: - Nib loading

    /**
     Called to load the nib in setupNib().

     - returns: UIView instance loaded from a nib file.
     */
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName(), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView()
    }

    // MARK: - Nib loading

    /**
     Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
     */
    public func setupNib() {
        self.nibView = self.loadNib()
        self.nibContainerView.addSubview(self.nibView!)
        self.nibView!.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": self.nibView!]
        self.nibContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: bindings))
        self.nibContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: bindings))
        self.awakeFromNib()
    }

    func awakeFromNib() {

    }
}

extension UIView {

    @objc public var nibContainerView: UIView {
        return self
    }
    /**
     Called in the default implementation of loadNib(). Default is class name.

     - returns: Name of a single view nib file.
     */
    @objc public func nibName() -> String {
        return type(of: self).description().components(separatedBy: ".").last!
    }
}

open class NibDesignable: UIView, NibDesignableProtocol {

    @objc open var nibView: UIView?

    override open var backgroundColor: UIColor? {
        didSet {
            nibView?.backgroundColor = backgroundColor
        }
    }

    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }

    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }

}

open class NibDesignableTableViewCell: UITableViewCell, NibDesignableProtocol {

    @objc open var nibView: UIView?

    open override var nibContainerView: UIView {
        return self.contentView
    }

    // MARK: - Initializer
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupNib()
    }

    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
}

open class NibDesignableControl: UIControl, NibDesignableProtocol {

    @objc open var nibView: UIView?

    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }

    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
}

open class NibDesignableCollectionReusableView: UICollectionReusableView, NibDesignableProtocol {

    @objc open var nibView: UIView?

    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }

    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
}

open class NibDesignableCollectionViewCell: UICollectionViewCell, NibDesignableProtocol {

    @objc open var nibView: UIView?

    open override var nibContainerView: UIView {
        return self.contentView
    }

    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }

    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
}
