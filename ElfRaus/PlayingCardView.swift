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
    var number: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var color: UIColor = UIColor.black{ didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { setNeedsDisplay() } }
    
    
    
    
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle, .font: font, .foregroundColor:color])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(numberString, fontSize: cornerFontSize)
    }
    

    private lazy var NumberLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureLabel(NumberLabel)
//        NumberLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        NumberLabel.center = CGPoint(x: bounds.maxX/2, y: bounds.maxY/2)
    }
    
    
        
    
    
    override func draw(_ rect: CGRect) {
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).setFill()
        roundedRect.fill()
        
        if isFaceUp {
            if let faceCardImage = UIImage(named: numberString, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            }
        } else {
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
    }
    
}

extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.55
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var numberString: String {
        switch number {
        case 0: return ""
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
