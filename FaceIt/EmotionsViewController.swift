//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Jessica on 3/26/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
        // use a dictionary to put the identifiers in the segue
    private let emotionalFaces: Dictionary<String,FacialExpression> = [
        "angry": FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "happy": FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried": FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)]
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Notifies the view controller that a segue is about to be performed
        var destinationvc = segue.destination     // a subclass of the  UIVc
        //destination: The view controller to display after the completion of the segue.
        // Get the faceview controller using segue.destinationViewController.
        if let navcon = destinationvc as? UINavigationController{
            destinationvc = navcon.visibleViewController ?? destinationvc   //optional
            // visiblevc: The view controller associated with the currently visible view in the navigation interface, it can belong either to the view controller at the top of the navigation stack || to a view controller that was presented modally on top of the navigation controller itself.
        }
        // if im preprare to segue sth and its a navController, prepare that instead(??)
        
        if let facevc = destinationvc as? FaceViewController{
            //now need the identifier
            if let identifier = segue.identifier{
                if let expression = emotionalFaces[identifier]{
                    facevc.expression = expression
                    if let sendingButton = sender as? UIButton{
                        facevc.navigationItem.title = sendingButton.currentTitle
                        //title The navigation item’s title displayed in the center of the navigation bar.
                    }
                }
            }
        }
        // Pass the selected object to the new view controller.
    }

}
