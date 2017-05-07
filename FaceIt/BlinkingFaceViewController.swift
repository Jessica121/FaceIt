//
//  BlinkingFaceViewController.swift
//  FaceIt
//
//  Created by Jessica on 5/6/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {

    var blinking = false{   //model
        didSet{
            blinkIfNeeded()
        }
    }
    
    //
    private struct BlinkRate{//how long for close and oepn
    static let closedDuration : TimeInterval = 0.4      //class or tye represent timeinterval doube
    
    static let openDuration : TimeInterval = 2.5
        
    //random
    }
    
    
    private func blinkIfNeeded(){   //blink is false not need to blink
        //turn on blinking when mvc appear.
        //set a timer make sure stop timer when mvc is not on screen
        if blinking{
            print(blinking)
            print("👀")
            faceView.eyesOpen = false //start when close eyes        no self. needed facevIEW IS SUPERCLASS protected no, public
            Timer.scheduledTimer(withTimeInterval: BlinkRate.closedDuration, repeats: false) { [weak self] timer in     //weak Self lifeCycle
                self?.faceView.eyesOpen = true
                Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false){ [weak self] timer in     //weak Self lifeCycle
                    self?.blinkIfNeeded()       //WAIT TILL OPEN DURATION (???)
            }// repet false call blink-if-needed again after i blinked once (???)
            //keep calling blink-is-needed until blink is not true anymore
        }
    }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)   //mvc on screen blinking
        blinking = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        blinking = false        //when disapper stop blinking stop timer going
    }

}
