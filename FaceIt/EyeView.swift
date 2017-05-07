//
//  EyeView.swift
//  FaceIt
//
//  Created by Jessica on 5/6/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class EyeView: UIView {

    var lineWidth: CGFloat = 5.0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var color: UIColor = UIColor.blue {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var _eyesOpen: Bool = true {//smooth change
        //加一个'_'就成了private var
        didSet{
            setNeedsDisplay()
        }
    }
    
    var eyesOpen: Bool{
        get {
            return _eyesOpen
        }
        set{
            if newValue != _eyesOpen {
                UIView.transition(with: self, duration: 0.4, options: [.transitionFlipFromTop], animations: {
                   //change the view to eyes open,
                    self._eyesOpen = newValue
                    // optional completion)), completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
            })//changed it animate from close to open
        }
    }
    }
    
    

    override func draw(_ rect: CGRect) {
        var path: UIBezierPath
        if eyesOpen{
            path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2))
        }else{
            path = UIBezierPath()
            path.move(to: CGPoint(x:bounds.minX, y: bounds.midY))
            path.addLine(to: CGPoint(x:bounds.maxX, y: bounds.midY))
        }
        
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
}
