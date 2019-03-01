//
//  PlayingCardView.swift
//  ElfRaus
//
//  Created by F.T. Boie on 27/02/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    
    @IBInspectable
    private var number: Int = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } } // 0 makes it disappear
    @IBInspectable
    private var color: UIColor = UIColor.black{ didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    private var atLeastOneCard: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } } //card is invisable if no card is given
    
    
    func setCardView(cardNumber:Int){
        number = cardNumber
        if cardNumber != 0{
            atLeastOneCard = true
        }
    }
    
    func setCardViewColor(cardColor:UIColor){
        color = cardColor
    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle, .font: font, .foregroundColor:color])
    }
    
    private var cardString: NSAttributedString {
        return centeredAttributedString(numberString, fontSize: centerFontSize)
    }
    

    private lazy var NumberLabel = createCenterLabel()
    
    private func createCenterLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureLabel(_ label: UILabel) {
        label.attributedText = cardString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !atLeastOneCard
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureLabel(NumberLabel)
        NumberLabel.center = CGPoint(x: bounds.maxX/2, y: bounds.maxY/2) // center card number lable
    }
    
    
        
    
    
    override func draw(_ rect: CGRect) {
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        if atLeastOneCard{
            #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).setFill()
        } else {
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).setFill()
        }
        roundedRect.fill()
    }
    
    
    
    
    
    
}

extension PlayingCardView {
    private struct SizeRatio {
        static let centerFontSizeToBoundsHeight: CGFloat = 0.55
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var centerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.centerFontSizeToBoundsHeight
    }
    
    private var numberString: String {
        switch number {
        case 0: return ""
        case nil: return ""
        case 1...20: return String(number)
        default: return "?"
        }
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }
    
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
    }
    
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y: origin.y), size: CGSize(width: width, height: size.height))
    }
}
