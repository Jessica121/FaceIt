//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Jessica on 3/24/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//


//MODEL

import Foundation

// UI independent representation /model/ of facial expression

struct FacialExpression
{
    enum Eyes: Int{
        case Open
        case Closed
        case Squinting                      //case that doesnt exist in controller, controller match what these cases mean and stand for, and tell the view, controller is to intreprete the model for the view( purpose)
        
    }
    
    enum EyeBrows: Int{
        case Relaxed
        case Normal
        case Furrowed
        
        func moreRelaxedBrow() -> EyeBrows{                     // function in enum
            return EyeBrows(rawValue: rawValue - 1) ?? .Relaxed
        }
        
        func moreFurrowedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    
    enum Mouth: Int{
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        
        func sadderMouth()->Mouth{
            return Mouth(rawValue: rawValue - 1) ?? . Frown
        }
        func happierMouth() ->Mouth{
            return Mouth(rawValue: rawValue + 1 ) ?? .Smile
        }       // take the current mouth, make it happier or sadder
    }
    
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
    
}
