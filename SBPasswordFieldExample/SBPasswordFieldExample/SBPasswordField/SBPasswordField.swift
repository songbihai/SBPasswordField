//
//  SBPasswordField.swift
//  SBPasswordFieldExample
//
//  Created by 宋碧海 on 2016/12/16.
//  Copyright © 2016年 songbihai. All rights reserved.
//  

import UIKit


@objc protocol SBPasscodeFieldDelegate: NSObjectProtocol {
    @objc optional func shouldInsert(_ passwordField: SBPasswordField, text: String) -> Bool
    @objc optional func shouldDeleteBackward(_ passwordField: SBPasswordField) -> Bool
    @objc optional func passwordDidChanged(_ passwordField: SBPasswordField, password: String?)
}

@objc protocol SBPasscodeFieldImageSource: NSObjectProtocol {
    @objc optional func imageSource(_ passwordField: SBPasswordField, dotImageAtIndex: Int, filled: Bool) -> UIImage
}


class SBPasswordField: UIControl {

    weak var dataSource: SBPasscodeFieldImageSource?
    weak var delegate: SBPasscodeFieldDelegate?
    
    var maximumLength: Int = 6
    
    var spacing: CGFloat = 5.0
    
    var dotSupViewColor: UIColor = UIColor.white
    
    var dotSize: CGSize = CGSize(width: 20, height: 20)
    
    var dotColor: UIColor = UIColor.black
    
    var keyboardType: UIKeyboardType = .default
    
    var insertRegularExpression: NSRegularExpression?
    
    var password: String? {
        set {
            guard let pass = newValue else { return }
            if pass.count > maximumLength {
                maxPassword = String(pass.prefix(maximumLength))
            }else {
                maxPassword = pass
            }
            setNeedsDisplay()
        }
        get {
            return maxPassword
        }
    }
    
    fileprivate var maxPassword: String? {
        didSet {
            guard oldValue != maxPassword else {
                return
            }
            delegate?.passwordDidChanged?(self, password: maxPassword)
        }
    }
    
    fileprivate var nonDigitRegularExpression: NSRegularExpression? = {
        let regularExpression = try? NSRegularExpression.init(pattern: "[^0-9]+", options: [])
        return regularExpression
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
    
    @objc fileprivate func didTouchUpInside() {
        self.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }

    override func draw(_ rect: CGRect) {
        let contentSize = rect.size
        let itemSize = CGSize(width: (contentSize.width - spacing * CGFloat(maximumLength - 1)) / CGFloat(maximumLength), height: contentSize.height)
        var origin = CGPoint(x: 0, y: 0)
        if let source = dataSource, source.responds(to: #selector(SBPasscodeFieldImageSource.imageSource(_:dotImageAtIndex:filled:))) {
            for index in 0..<maximumLength {
                var image: UIImage?
                if let maxPass = maxPassword, index < maxPass.count {
                    image = source.imageSource!(self, dotImageAtIndex: index, filled: true)
                }else {
                    image = source.imageSource!(self, dotImageAtIndex: index, filled: false)
                }
                let imageFrame = CGRect(x: origin.x + (itemSize.width - dotSize.width) / 2, y: origin.y + (contentSize.height - dotSize.height) / 2, width: dotSize.width, height: dotSize.height)
                image?.draw(in: imageFrame)
                origin.x += (itemSize.width + spacing)
            }
        }else {
            let context = UIGraphicsGetCurrentContext()
            for index in 0..<maximumLength {
                context?.setFillColor(dotSupViewColor.cgColor)
                let dotSupFrame = CGRect(x: origin.x, y: origin.y, width: itemSize.width, height: contentSize.height)
                context?.fill(dotSupFrame)
                if let maxPass = maxPassword, index < maxPass.count {
                    context?.setFillColor(dotColor.cgColor)
                    let circleFrame = CGRect(x: origin.x + (itemSize.width - dotSize.width) / 2, y: origin.y + (contentSize.height - dotSize.height) / 2, width: dotSize.width, height: dotSize.height)
                    context?.fillEllipse(in: circleFrame)
                }
                origin.x += (itemSize.width + spacing)
            }
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
}

extension SBPasswordField: UIKeyInput {
    var hasText : Bool {
        return maxPassword?.count ?? 0 > 0
    }
    
    func insertText(_ text: String) {
        guard isEnabled else { return }
        
        var replacingText: String = ""
        if nonDigitRegularExpression != nil && keyboardType == .numberPad {
            replacingText  = nonDigitRegularExpression!.stringByReplacingMatches(in: text, options: [], range: NSMakeRange(0, text.count), withTemplate: "")
        }else {
            replacingText = text
        }
        
        if let regularExpression = insertRegularExpression {
            replacingText = regularExpression.stringByReplacingMatches(in: replacingText, options: [], range: NSMakeRange(0, replacingText.count), withTemplate: "")
        }
        
        guard replacingText.count > 0 else { return }
        
        let newCount = replacingText.count + (maxPassword?.count ?? 0)
        if newCount > maximumLength {
            return
        }
        
        let shoudInsert = delegate?.shouldInsert?(self, text: replacingText)
        if let shoud = shoudInsert {
            if !shoud {
                return
            }
        }
        
        if let maxPass = maxPassword {
            maxPassword = maxPass + replacingText
        }else {
            maxPassword = replacingText
        }
        
        setNeedsDisplay()
        sendActions(for: .editingChanged)
        
    }
    
    func deleteBackward() {
        guard isEnabled else { return }
        
        let shouldDeleteBackward = delegate?.shouldDeleteBackward?(self)
        if let shoud = shouldDeleteBackward {
            if !shoud {
                return
            }
        }
        
        if let maxPass = maxPassword {
            if maxPass.count == 0 {
                return
            }
        }else {
            return
        }
        
        if let maxPass = maxPassword {
            maxPassword?.removeSubrange(maxPass.index(before: maxPass.endIndex)..<maxPass.endIndex)
        }
        
        setNeedsDisplay()
        sendActions(for: .editingChanged)
    }
}
