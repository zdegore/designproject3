//
//  FadeViewController.swift
//  Basic Chat MVC
//
//  Created by Degore, Zachary on 12/15/22.
//

import UIKit

class FadeViewController: UIViewController {
    
    
    
    //variable declaration
    @IBOutlet weak var SliderBrightness: UISlider!
    @IBOutlet weak var SliderSpeed: UISlider!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    
    //update the values for the sliders and output the result
    @IBAction func SliderAction(sender: AnyObject){
        
        Label2.text = String(SliderSpeed.value)
        Label1.text = String(SliderBrightness.value)

        
    }
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
