//
//  cardView.swift
//  ElfRaus
//
//  Created by F.T. Boie on 14/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import UIKit

class cardView: UIButton {
    
    
    //VARIABELS
    @IBInspectable
    private var number: Int = 22 { didSet { setNeedsDisplay(); setNeedsLayout() } } // 0 makes it disappear, -11 makes the 11 only show slighly
    @IBInspectable
    private var color: UIColor = UIColor.black{ didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    private var atLeastOneCard: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } } //card is invisable if no card is given
    private var interactable = false //interactable for hand cards, not interactable for table cards; dependent on card location
    
    //how opaque should 11 be at the beginning
    private let howOpaque:CGFloat = 0.2
    
    
    //FUNCTIONS
    
    func setHandCardView(card:Card?){
        if (card != nil) {
            self.interactable = true
            self.number = card!.number
            self.color = card!.color
            self.alpha = 1
            self.atLeastOneCard = true
        } else {
            self.isEnabled = false
            self.number = 0
            self.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.02682108275)
            self.alpha = howOpaque
        }
    }
    
    
    
    func setCardView(cardNumber:Int){
        switch cardNumber {
        case 0: number = cardNumber; self.alpha = 1.0; atLeastOneCard = false
        case -11: number = 11; self.alpha = howOpaque; atLeastOneCard = true
        case 1...20: number = cardNumber; self.alpha = 1.0;  atLeastOneCard = true
        default:  number = -1; self.alpha = 1.0; atLeastOneCard = true    // shows -1 if it fucked up
        }
    }
    
    func setCardViewColor(cardColor:UIColor){
        self.color = cardColor
        self.interactable = false
    }
    
    func setInteractable(_ interactable: Bool){
        self.interactable = interactable
    }
    
    private func configureButton() {
        self.setAttributedTitle(cardString, for: .normal)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        if atLeastOneCard {
            UIColor.white.setFill()
        } else {
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).setFill()
        }
        roundedRect.fill()
        configureButton()
    }

}

extension cardView {
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
        case 1...20: return String(number)
        default: return "?"
        }
    }
}

