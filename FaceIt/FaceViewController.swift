//
//  ViewController.swift
//  FaceIt
//
//  Created by Jessica on 3/12/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//


//CONTROLLER

import UIKit

class FaceViewController: UIViewController {

    //MARK: MODEL
    var expression: FacialExpression = FacialExpression(eyes: .Closed, eyeBrows: .Normal, mouth: .Smile)  {// default constructor
     didSet{
        updateUI()          //in case it changes to update the view
    // didSet only works for var, not classes
        
    }
    }
    //didSet didnt get called cuz its in the initilization
    
    
    //MARK: VIEW
    @IBOutlet weak var faceView: FaceView!{    //opional
        didSet{
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target:faceView, action: #selector(FaceView.changeScale(recognizer:))))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))     //no argument in the increaseHappiness func
                // why the seletor method is in viewController?
            
            happierSwipeGestureRecognizer.direction = .up
            //The permitted direction of the swipe for this gesture recognizer.
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseSadness))
            // action 是否必须属于target???
            
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            faceView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector (FaceViewController.changeBrows(recognizer:))))

            updateUI()
        }
        
    }
    // target, pinch only change the faceview not the model, so put faceView
    // for the faceview to handle it, it must have some gesture handler avaiable to the controller, public method handle the pinch
    //make a pointer to update the faceview

    
//    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
//        if recognizer.state == .ended{
//            switch expression.eyes{
//            case .Open : expression.eyes = .Closed
//            case .Closed : expression.eyes = .Open
//            case .Squinting : break
//            }
//        }
//    }
    
    
    @IBAction func shakeHead(_ sender: UITapGestureRecognizer) {
        
        shakeHead()
    }
    
    
    
    func changeBrows(recognizer:UIRotationGestureRecognizer){
        switch recognizer.state{
        case .changed, .ended:
            if recognizer.rotation >  CGFloat(M_PI/4){
                expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
                recognizer.rotation=0.0
            }else if recognizer.rotation < -CGFloat(M_PI/4){
                expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
                recognizer.rotation = 0.0 //RESET
            }
        default: break
            }
        }
    
    //shake head implemttn
    private struct HeadShake{
        static let angle = CGFloat.pi/6     //radians angle
        static let segmentDration: TimeInterval = 0.5       // each head-shake has 3 segs(???)
    }
    
    private func rotateFace(by angle: CGFloat){        //by???
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private func shakeHead(){
        UIView.animate(
            withDuration: HeadShake.segmentDration,
            animations: {self.rotateFace(by: HeadShake.angle)},
            completion: {finished in        //mmr cycle no need weak self in the midd of viw
                if finished{
                    //animate going back to the right
                    UIView.animate(withDuration: HeadShake.segmentDration, animations: {self.rotateFace(by: -HeadShake.angle*2)}, completion: { finished in
                        //rotate back to the midding
                        UIView.animate(withDuration: HeadShake.segmentDration, animations: {self.rotateFace(by: HeadShake.angle)})
                    })
                }
        })
    }
    
    
    func increaseHappiness()
    {
        expression.mouth = expression.mouth.happierMouth()      //return a enum in model
        // everytime it changes the expression, the updateUI will be called, mouthcurvature
    }
    
    func increaseSadness()
    {
        expression.mouth = expression.mouth.sadderMouth()           // change the model(???)
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown:-1.0,.Grin:0.5,.Smile:1.0, .Smirk:-0.5, .Neutral:0.0 ]
    // crate a dic on the fly by [], match the mouth in the model and in the view, key:mouthcurvatures in model, value, mouthcurvature in view
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed:0.5, .Normal:0.0, .Furrowed:-0.5]
    
    
    private func updateUI(){    // talk to the pointer to change it
        if faceView != nil{
        switch expression.eyes{
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
            }
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        //this mouthcurvature has something to do with mouth in the expression, how to convert the enum mouth to the curvature, by creating a dictinary
        //?? denote the DEFALUT value, take the double turn into nil, when the thing in the dictionary doesnt exist
        
        //same with eyebrows and stuff
        faceView.eyebrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
    }
    }


}


