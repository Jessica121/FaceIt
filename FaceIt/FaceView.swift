//
//  FaceView.swift
//  FaceIt
//
//  Created by Jessica on 3/12/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//


//VIEW

import UIKit

@IBDesignable

class FaceView: UIView {
    @IBInspectable
    var scale: CGFloat = 0.90       { didSet{ setNeedsDisplay()} }//scale the skull rather than 紧挨着 edge
        
     @IBInspectable
    var mouthCurvature: Double = 1.0
        { didSet{ setNeedsDisplay()}}
     @IBInspectable
    var eyesOpen: Bool = true //false
        { didSet{ //setNeedsDisplay()
            leftEye.eyesOpen = eyesOpen
            rightEye.eyesOpen = eyesOpen        //forward
            
        }}   //eyesOpen dont need set-needs-display dont draw , draw by subview
     @IBInspectable
    var eyebrowTilt : Double = 1.0
        { didSet{ setNeedsDisplay()}}
     @IBInspectable
    var color: UIColor = UIColor.red
        { didSet{ setNeedsDisplay()
        leftEye.color = color
        rightEye.color = color
        }
    }
     @IBInspectable
    var lineWidth: CGFloat = 5.0                    //THESE PUBLIC VARS ARE likely to be used by the controller
        { didSet{ setNeedsDisplay()
        leftEye.lineWidth = lineWidth
        rightEye.lineWidth = lineWidth
        
        }}
   // relative size of the eyes
    

    
    //public changeScale func
    func changeScale(recognizer: UIPinchGestureRecognizer){         switch recognizer.state{
        case .changed, .ended:
            scale *= recognizer.scale       //var scale: CGFloat { get set } 是UIPinchRecognizer 的一个var
            recognizer.scale = 1.0          // reset let it be not accumulative
        default: break
        }
    }

    
    private var skullRadius : CGFloat {
        
    return min(bounds.size.width, bounds.size.height) / 2 * scale      //drawing in the subclass, not in superclass, using bounds
                                                                                             //cannot use instance mmbr bounds within property initilzer, put it as a computed property
                                                                                             // if there is onlt GET no SET no need to put get{}
    }
    private var skullCenter : CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    private struct Ratios {          // used to draw the eyes and the mouth         // the ratio between the radius and the eye size, to make the whole thing responsive **, i think to draw anything needs to connects every part for any application
        static let SkullRadiusToEyeOffset : CGFloat = 3             //create constants in swift, struct, name, inside the { type variable(static), let/var 声明, name, :type, value
        static let SkullRadiusToEyeRadius : CGFloat = 10          // and the name of the struct is 大写的，属于type
        static let SkullRadiusToMouthWidth : CGFloat = 1         // the constants are used/accessed by StuctName(NameOfTheType).PropertyName(Value), e.g. Ratios.(dot)SkullRadius...
        static let SkullRadiusToMouthHeight : CGFloat = 3
        static let SkullRadiusToMouthOffset : CGFloat = 3
        static let SkullRadiusToBrowOffset : CGFloat = 5
        
    }
    
    private enum Eye {
        case Left
        case Right                          //hav a enum that can call the eye
    }
    
    private func pathForCircleCenteredAtPoint( midPoint: CGPoint, withRadius radius: CGFloat ) -> UIBezierPath{            // UTILITY FUNCTION
        
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false)    //UIBezierPath is a round circle
        
        path.lineWidth=lineWidth                                                                                                                                                                       //radius is internal name, withRadius is external name, func declaration EXTERNAL NAME INTERNAL NAME:type
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint{
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset         //all base on skullradius and center
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left : eyeCenter.x-=eyeOffset
        case .Right : eyeCenter.x+=eyeOffset
        }
        return eyeCenter
    }
    
//    private func pathForEye(eye:Eye) -> UIBezierPath{
//        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
//        let eyeCenter = getEyeCenter(eye: eye)       //OOP
//        if eyesOpen{
//        return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)         //用函数的时候冒号：后面是argument的名字，不是type。定义函数时：后面是type
//        } else{
//            let path = UIBezierPath()
//            path.move(to: CGPoint(x:eyeCenter.x-eyeRadius, y:eyeCenter.y))
//            path.addLine(to: CGPoint(x:eyeCenter.x+eyeRadius, y:eyeCenter.y))
//            path.lineWidth = lineWidth
//            return path
//        }
//    }
     //把眼睛放到view里去animate
    
    
    //creating eyeviews put them in the right place
    
    private lazy var leftEye:EyeView = self.createEye()      //lazy no one will call unless initilized
    //specify the lazy type
    //trying to find a static func createEye                //separate view
    //put it into self, instance
    private lazy var rightEye:EyeView = self.createEye()
    
    private func createEye() -> EyeView{
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = color //color of the face
        eye.lineWidth = lineWidth
        addSubview(eye) ///what is subview????
        return eye
    }
    
    private func positionEye(_ eye: EyeView, center:CGPoint){
    let size = skullRadius/Ratios.SkullRadiusToEyeOffset * 1    //depends on the size of the face
        eye.frame = CGRect (origin: CGPoint.zero, size: CGSize(width:size, height:size))//square
        //center 的zero
        eye.center = center
    }
    
    //view when bounds changes
    override func layoutSubviews() {
        super.layoutSubviews()
        //sent to all views when bound changes or relayout
        positionEye(leftEye, center: getEyeCenter(eye: .Left))
        positionEye(rightEye, center: getEyeCenter(eye: .Right))
    }
    
     private func pathForMouth() -> UIBezierPath{           //useing curves
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthHeight / 2, width: mouthWidth, height:mouthHeight)                //draw the mouth within the rect
        
        let smileOffset = CGFloat(max(-1,min(mouthCurvature,1))) * mouthRect.height
        let start = CGPoint(x:mouthRect.minX, y:mouthRect.minY)
        let end = CGPoint (x:mouthRect.maxX, y:mouthRect.minY)
        let cp1 = CGPoint (x: mouthRect.minX+mouthRect.width/3, y: mouthRect.minY+smileOffset)
        let cp2 = CGPoint (x: mouthRect.maxX-mouthRect.width/3, y: mouthRect.minY+smileOffset)
        
        let path = UIBezierPath()
        path.move(to : start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
        
    }
    
    private func pathForBrow(eye:Eye)-> UIBezierPath
    {
        var tilt=eyebrowTilt
        switch eye{
        case .Left: tilt *= -1.0
        case .Right: break
        }
        var browCenter=getEyeCenter(eye: eye)
        browCenter.y-=skullRadius/Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius/Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1,min(1,tilt)))*eyeRadius / 2
        let browStart = CGPoint(x:browCenter.x - eyeRadius, y: browCenter.y-tiltOffset)
        let browEnd = CGPoint(x:browCenter.x + eyeRadius, y: browCenter.y+tiltOffset)
        let path=UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth=lineWidth
        return path
        
    }
    
    
    override func draw(_ rect: CGRect) {
        
        /*let height = bounds.size.height     //drawing in the subclass, not in superclass, using bounds ,
        let width = bounds.size.width
        let skullRadius = min(width, height)/2
        let skullCenter = CGPoint(x: bounds.midX, y: bounds.midY)*/
        
        color.set()   //set both the fill and the stroke (how to connect to this particular drawing???)
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()      // draw the with the linewidth and the color it sets
       // pathForEye(eye: .Left).stroke()
       // pathForEye(eye: .Right).stroke()
       // pathForEye(eye: .Left).fill()
        //pathForEye(eye: .Right).fill()
        pathForMouth().stroke()
        pathForBrow(eye: .Left).stroke()
        pathForBrow(eye: .Right).stroke()
    }

}
