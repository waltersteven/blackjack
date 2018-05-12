//
//  CardView.swift
//  blackjack
//
//  Created by ulima on 8/05/18.
//  Copyright © 2018 ulima. All rights reserved.
//

import UIKit

protocol OnTapDelegate {
    func onTapDelegate(validTap: Bool, score: Int, turn: Int)
}



class CardView: UIView {
    var palo: String?
    var number: Int?
    var back: String?
    var turn: Int?
    var actualTurn: Int?
    var onTapDelegate: OnTapDelegate?
    var enable: Bool? //
    var faceUp : Bool? {
        didSet {
            for view in self.subviews {
                view.removeFromSuperview()
            }
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let tapRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if let status = faceUp {
            if status {
                drawCard()
            } else {
                 drawBack()
            }
        }
    }
    func drawBack(){
        if let back = back, let image = UIImage(named: back){
            let height = image.cgImage!.height
            let width = image.cgImage!.width

            let cardView = UIImageView(frame: CGRect(x: Int(frame.width)/2 - width/2, y: 0, width: width, height: height))
            cardView.frame.origin.x = 0
            cardView.frame.origin.y = 0

            let aspectRatio = cardView.frame.width / cardView.frame.height
            cardView.frame.size.width = frame.size.width
            cardView.frame.size.height = frame.size.width / aspectRatio
            cardView.image = image
            addSubview(cardView)

            // Igualamos el alto de la imageview al alto de figuritaview
            self.frame.size.height = cardView.frame.size.height
        }
        
    }
    
    func drawCard() {
        if let palo = palo, let image = UIImage(named: palo){
            let height = image.cgImage!.height
            let width = image.cgImage!.width
            
            let cardView = UIImageView(frame: CGRect(x: Int(frame.width)/2 - width/2, y: 0, width: width, height: height))
            cardView.frame.origin.x = 0
            cardView.frame.origin.y = 0
            
            let aspectRatio = cardView.frame.width / cardView.frame.height
            cardView.frame.size.width = frame.size.width
            cardView.frame.size.height = frame.size.width / aspectRatio
            cardView.image = image
            addSubview(cardView)
            
            // Igualamos el alto de la imageview al alto de figuritaview
            self.frame.size.height = cardView.frame.size.height
        }
        
        drawNumber(region: "up")
        drawNumber(region: "down")
   }
    
    func drawNumber(region: String) {
        
        let numberLabel: UILabel
        
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont(name: "Arial", size: 12.0)!
        ]
        
        if region == "up" {
            numberLabel = UILabel(frame: CGRect(x: 6, y: 6, width: 14, height: 14))
        } else {
            numberLabel = UILabel(frame: CGRect(x: 61, y: 103, width: 14, height: 14))
        }
        
        if let num = number {
            numberLabel.attributedText = NSAttributedString(string: String(num), attributes: attributes)
        } else {
            numberLabel.attributedText = NSAttributedString(string: "-", attributes: attributes)
        }
        
        numberLabel.textAlignment = NSTextAlignment.center
        numberLabel.textColor = UIColor.black
        
        addSubview(numberLabel)
    
    }
    
    @objc private func onTap(_ gestureRecognizer: UIGestureRecognizer) {
        if let delegate = onTapDelegate {
            if faceUp == false { //para no volver a voltearlo
                if self.turn! == self.actualTurn! && self.enable! == true { // validando el turno
                    faceUp = !faceUp!
                }
                if let turn = self.turn, let num = self.number {
                    delegate.onTapDelegate(validTap: turn == self.actualTurn! && self.enable! == true,score: num, turn: turn)
                }
            }
        }

    }

}
